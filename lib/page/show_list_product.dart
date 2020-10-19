import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungtvdirect/models/goods_model.dart';
import 'package:ungtvdirect/models/sqlite_model.dart';
import 'package:ungtvdirect/utility/my_style.dart';
import 'package:ungtvdirect/utility/sqlite_helper.dart';

class ShowListProduct extends StatefulWidget {
  @override
  _ShowListProductState createState() => _ShowListProductState();
}

class _ShowListProductState extends State<ShowListProduct> {
  List<GoodsModel> models = List();
  int page = 1, amount = 1;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('At Position End Screen');
        setState(() {
          page++;
          readData(page);
        });
      }
    });

    readData(page);
  }

  Future<Null> readData(int page) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('Token');
    token = 'Basic $token';
    print('token ==>> $token');

    String url = 'https://www.tvdirect.tv/t/goods?page=$page';
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
              controller: scrollController,
              itemCount: models.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => showDetailDialog(models[index]),
                child: Card(
                  color: index % 2 == 0
                      ? Colors.green.shade100
                      : Colors.green.shade300,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width * 0.5 - 8,
                        height: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              models[index].gOODSNAME,
                              style: MyStyle().titleH2(),
                            ),
                            Text(
                                'ราคา ${models[index].sALEPRICE.toString()} บาท'),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: CachedNetworkImage(
                          imageUrl: models[index].iMAGE,
                          placeholder: (context, url) =>
                              MyStyle().showProgress(),
                          errorWidget: (context, url, error) =>
                              MyStyle().showQuestion(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<Null> showDetailDialog(GoodsModel model) async {
    showDialog(
      context: context,
      builder: (context) {
        amount = 1;
        return StatefulBuilder(
          builder: (context, setState) => SimpleDialog(
            title: ListTile(
              leading: Container(
                width: 48,
                child: Image.asset('images/logo.png'),
              ),
              title: Text(model.gOODSNAME),
            ),
            children: [
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Text('Category : ${model.cATEGORYNAME}'),
              ),
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Text(
                  'Price : ${model.sALEPRICE} บาท',
                  style: MyStyle().pinkText(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Text(
                  'Stock : ${model.sTOCK}',
                  style: MyStyle().darkText(),
                ),
              ),
              CachedNetworkImage(
                imageUrl: model.iMAGE,
                placeholder: (context, url) => MyStyle().showProgress(),
                errorWidget: (context, url, error) => MyStyle().showQuestion(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.green.shade700,
                    ),
                    onPressed: () {
                      setState(() {
                        if (amount < model.sTOCK) {
                          amount++;
                        }
                      });
                    },
                  ),
                  Text('$amount'),
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      color: Colors.red.shade700,
                    ),
                    onPressed: () {
                      setState(() {
                        if (amount > 1) {
                          amount--;
                        }
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  FlatButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      SqliteHelper helper = SqliteHelper();

                      SqliteModel sqliteModel = SqliteModel(
                          goodscode: model.gOODSCODE,
                          goodsname: model.gOODSNAME,
                          salseprice: model.sALEPRICE.toString(),
                          amount: amount.toString(),
                          sum: ((model.sALEPRICE) * (amount)).toString());

                      print('sqliteModel ==>> ${sqliteModel.toJson().toString()}');

                      await helper.insertValueToDatabase(sqliteModel);
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.green.shade700,
                    ),
                    label: Text('Add to Cart'),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red.shade700,
                    ),
                    label: Text('Cancel'),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
