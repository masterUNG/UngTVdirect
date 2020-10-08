import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungtvdirect/models/goods_model.dart';
import 'package:ungtvdirect/utility/my_style.dart';

class ShowListProduct extends StatefulWidget {
  @override
  _ShowListProductState createState() => _ShowListProductState();
}

class _ShowListProductState extends State<ShowListProduct> {
  List<GoodsModel> models = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('Token');
    token = 'Basic $token';
    print('token ==>> $token');

    String url = 'https://www.tvdirect.tv/t/goods?page=5';
    Map<String, dynamic> header = {"Authorization": token};
    await Dio().get(url, options: Options(headers: header)).then((value) {
      print('value ==>> $value');
      for (var map in value.data['data']) {
        GoodsModel model = GoodsModel.fromJson(map);
        setState(() {
          models.add(model);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: models.length == 0
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: models.length,
              itemBuilder: (context, index) => Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(models[index].gOODSNAME),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: CachedNetworkImage(
                      imageUrl: models[index].iMAGE,
                      placeholder: (context, url) => MyStyle().showProgress(),
                      errorWidget: (context, url, error) => MyStyle().showQuestion(),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
