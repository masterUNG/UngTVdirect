import 'package:flutter/material.dart';
import 'package:ungtvdirect/models/sqlite_model.dart';
import 'package:ungtvdirect/utility/my_style.dart';
import 'package:ungtvdirect/utility/sqlite_helper.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<SqliteModel> sqliteModels = List();
  int total;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    try {
      var result = await SqliteHelper().readDatabase();
      if (result != null) {
        setState(() {
          sqliteModels = result;
          calculateTotal();
        });
      }
    } catch (e) {}
  }

  Future<Null> calculateTotal() async {
    total = 0;
    for (var model in sqliteModels) {
      setState(() {
        total = total + int.parse(model.sum);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cloud_upload),
        onPressed: () async {
          await SqliteHelper().deleteAll().then((value) => readSQLite());
        },
      ),
      appBar: AppBar(
        title: Text('ตระกร้า'),
      ),
      body: sqliteModels.length == 0
          ? Text('ยังไม่มี สินค้าใน ตระกร้า')
          : Column(
              children: [
                buildHead(),
                buildListView(),
                Divider(
                  thickness: 1,
                  color: Colors.blue.shade700,
                ),
                buildbutton(),
              ],
            ),
    );
  }

  Row buildbutton() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Total :',
                style: MyStyle().titleH1(),
              ),
              SizedBox(
                width: 30,
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(total == null ? '' : total.toString()),
        ),
      ],
    );
  }

  Container buildHead() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.black38),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('สินค้า'),
          ),
          Expanded(
            flex: 1,
            child: Text('ราคา'),
          ),
          Expanded(
            flex: 1,
            child: Text('จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: Text('รวม'),
          ),
        ],
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) => Dismissible(
        background: Container(
          decoration: BoxDecoration(color: Colors.red),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text('Delete'),
                ],
              ),
            ],
          ),
        ),
        onDismissed: (direction) async {
          print('dimissible ==>> ${sqliteModels[index].id}');
          await SqliteHelper()
              .deleteValueById(sqliteModels[index].id)
              .then((value) {
            readSQLite();
          });
        },
        key: Key(sqliteModels[index].goodsname),
        child: Container(
          decoration: BoxDecoration(
              color: index % 2 == 0 ? Colors.grey.shade300 : Colors.white),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(sqliteModels[index].goodsname),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(sqliteModels[index].salseprice),
              ),
              Expanded(
                flex: 1,
                child: Text(sqliteModels[index].amount),
              ),
              Expanded(
                flex: 1,
                child: Text(sqliteModels[index].sum),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
