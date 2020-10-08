import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungtvdirect/models/user_model.dart';
import 'package:ungtvdirect/page/my_service.dart';
import 'package:ungtvdirect/page/register.dart';
import 'package:ungtvdirect/utility/my_constant.dart';
import 'package:ungtvdirect/utility/my_style.dart';
import 'package:ungtvdirect/utility/normal_dialog.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool redEyebol = true, statusLogin = false;
  String user, password;

  @override
  void initState() {
    super.initState();
    // checkPreferance();
  }

  Future<Null> checkPreferance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('Name') != null) {
      routeToService();
    } else {
      setState(() {
        statusLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: statusLogin ? MyStyle().showProgress() : buildContainer(),
    );
  }

  Container buildContainer() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
            colors: <Color>[Colors.white, MyStyle().primaryColors],
            radius: 1,
            center: Alignment(0, -0.2)),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildLogo(),
              buildText(),
              buildTextFieldUser(),
              buildTextFieldPassword(),
              buildElevatedButton(),
              buildTextButton()
            ],
          ),
        ),
      ),
    );
  }

  TextButton buildTextButton() => TextButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Register(),
            )),
        child: Text(
          'New Register',
          style: MyStyle().pinkText(),
        ),
      );

  Widget buildElevatedButton() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: RaisedButton(
        color: MyStyle().primaryColors,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () => processLogin(),
        child: Text(
          'Login',
          style: MyStyle().whiteText(),
        ),
      ),
    );
  }

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
          obscureText: redEyebol,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: redEyebol ? Colors.green : Colors.red,
              ),
              onPressed: () {
                setState(() {
                  redEyebol = !redEyebol;
                });

                print('redEysbol = $redEyebol');
              },
            ),
            prefixIcon: Icon(Icons.lock),
            hintText: 'Password :',
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.purple)),
          ),
        ),
      );

  Text buildText() => Text(
        'Ung TV Direct',
        style: MyStyle().titleH1(),
      );

  Container buildLogo() {
    return Container(
      width: 120,
      child: Image.asset('images/logo.png'),
    );
  }

  Future<Null> processLogin() async {
    if (user == null || user.isEmpty || password == null || password.isEmpty) {
      normalDialog(context, 'Have Space ? Please Fill All Blank');
    } else {
      String urlAPI =
          '${MyConstant().domain}/TVdirect/getUserWhereUserUng.php?isAdd=true&User=$user';
      await Dio().get(urlAPI).then((value) {
        if (value.toString() == 'null') {
          normalDialog(context, 'ไม่มี $user นี้ ใน ฐานข้อมูล เขาเรา');
        } else {
          print('value = $value');
          var result = json.decode(value.data);
          print('result = $result');
          for (var json in result) {
            print('json = $json');
            UserModel model = UserModel.fromJson(json);
            if (password == model.password) {
              savePreferance(model);
            } else {
              normalDialog(context, 'Password False ? Please Try Again');
            }
          }
        }
      });
    }
  }

  void routeToService() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MyService(),
        ),
        (route) => false);
  }

  Future<Null> savePreferance(UserModel model) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('Name', model.name);
    // preferences.setString('id', model.id);
    routeToService();
  }
}
