import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungtvdirect/page/authen.dart';
import 'package:ungtvdirect/page/information.dart';
import 'package:ungtvdirect/page/show_cart.dart';
import 'package:ungtvdirect/page/show_list_product.dart';
import 'package:ungtvdirect/utility/my_style.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  String name, avatar;
  Widget currentWidget = ShowListProduct();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFromPreferance();
  }

  Future<Null> loadFromPreferance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('Name');
      avatar = preferences.getString('Avatar');
      // avatar = 'https://www.tvdirect.tv/goodsimg/0000/440/301/440301_M.jpg';
    });
    print('name = $name, avatar = $avatar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowCart(),
                )),
          ),
        ],
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildListTileShowListProduct(),
                buildListTileInformation(),
              ],
            ),
            buildMenuSingOut(),
          ],
        ),
      ),
      body: currentWidget,
    );
  }

  ListTile buildListTileShowListProduct() => ListTile(
        leading: Icon(Icons.list),
        title: Text('Show List Product'),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = ShowListProduct();
          });
        },
      );

  ListTile buildListTileInformation() => ListTile(
        leading: Icon(Icons.info_rounded),
        title: Text('Information'),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = Information();
          });
        },
      );

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      accountName: Text('Name'),
      accountEmail: Text('Login'),
      currentAccountPicture:
          avatar == null ? MyStyle().showQuestion() : buildCachedNetworkImage(),
    );
  }

  CachedNetworkImage buildCachedNetworkImage() {
    return CachedNetworkImage(
      imageUrl: avatar,
      placeholder: (context, url) => MyStyle().showProgress(),
      errorWidget: (context, url, error) => MyStyle().showQuestion(),
    );
  }

  Column buildMenuSingOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildSignOut(),
      ],
    );
  }

  Container buildSignOut() {
    return Container(
      decoration: BoxDecoration(color: Colors.red.shade700),
      child: ListTile(
        onTap: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.clear();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => Authen(),
              ),
              (route) => false);
        },
        leading: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        title: Text(
          'Sign Out',
          style: MyStyle().whiteText(),
        ),
      ),
    );
  }
}
