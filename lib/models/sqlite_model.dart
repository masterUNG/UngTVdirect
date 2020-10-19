class SqliteModel {
  int id;
  String goodscode;
  String goodsname;
  String salseprice;
  String amount;
  String sum;

  SqliteModel(
      {this.id,
      this.goodscode,
      this.goodsname,
      this.salseprice,
      this.amount,
      this.sum});

  SqliteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodscode = json['goodscode'];
    goodsname = json['goodsname'];
    salseprice = json['salseprice'];
    amount = json['amount'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goodscode'] = this.goodscode;
    data['goodsname'] = this.goodsname;
    data['salseprice'] = this.salseprice;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    return data;
  }
}

