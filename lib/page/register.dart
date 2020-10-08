import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';
import 'package:ungtvdirect/models/res_authen_model.dart';
import 'package:ungtvdirect/models/user_model.dart';
import 'package:ungtvdirect/page/authen.dart';
import 'package:ungtvdirect/utility/my_constant.dart';
import 'package:ungtvdirect/utility/my_style.dart';
import 'package:ungtvdirect/utility/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  double lat, lng;
  String name, user, password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData data = await findLocationData();
    setState(() {
      lat = data.latitude;
      lng = data.longitude;
    });
    print('lat = $lat, lng = $lng');
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(right: 60),
        child: FloatingActionButton(
          backgroundColor: MyStyle().primaryColors,
          onPressed: () {
            if (name == null ||
                name.isEmpty ||
                user == null ||
                user.isEmpty ||
                password == null ||
                password.isEmpty) {
              print('Have Space');
              normalDialog(context, 'Have Space ? Please Fill Every Blank');
            } else {
              registerThread();
              // checkUser();
            }
          },
          child: Icon(Icons.cloud_upload),
        ),
      ),
      appBar: AppBar(
        title: Text('สมัครสมาชิก'),
        backgroundColor: MyStyle().primaryColors,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              buildTextFieldName(),
              buildTextFieldUser(),
              buildTextFieldPassword(),
              lat == null ? MyStyle().showProgress() : buildMap(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMap() => Expanded(
          child: Container(
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(lat, lng),
            zoom: 16,
          ),
          mapType: MapType.normal,
          onMapCreated: (controller) {},
          markers: <Marker>[
            Marker(
              markerId: MarkerId('idUser'),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                  title: 'คุณอยู่ที่นี่', snippet: 'lat = $lat, lng = $lng'),
            ),
          ].toSet(),
        ),
      ));

  Widget buildTextFieldName() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => name = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.face_outlined),
            hintText: 'Name :',
            hintStyle: MyStyle().darkText(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().darkColor),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.purple)),
          ),
        ),
      );

  Widget buildTextFieldUser() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle),
            hintText: 'User :',
            hintStyle: MyStyle().darkText(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().darkColor),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.purple)),
          ),
        ),
      );

  Widget buildTextFieldPassword() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_open),
            hintText: 'Password :',
            hintStyle: MyStyle().darkText(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().darkColor),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.purple)),
          ),
        ),
      );

  Future<Null> registerThread() async {
    String urlAPI = 'https://api.tvdirect.tv/t/register';

    UserModel model = UserModel(
        name: name, username: user, password: password, lat: lat, lng: lng);

    Map<String, dynamic> map = model.toJson();

    Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate x509certificate, String string, int port) => true;
      return client;
    };
    await dio.post(urlAPI, data: json.encode(map)).then((value) {
      print('value ==>> $value');
      ResAuthenModel model = ResAuthenModel.fromJson(value.data);
      if (model.status) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Authen(user: user, password: password,),), (route) => false);
      } else {
        normalDialog(context, '$user มีคนอื่น ใช้ไปแล้ว กรุณาเปลี่ยนใหม่ ?');
      }
    });
  }

  
}
