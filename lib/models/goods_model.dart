class GoodsModel {
  int nUM;
  String gOODSCODE;
  String gOODSNAME;
  int cUSTPRICE;
  int sALEPRICE;
  int fREIGHT;
  String cATEGORYCODE;
  String cATEGORYNAME;
  String sTATUS;
  int sTOCK;
  String iMAGE;

  GoodsModel(
      {this.nUM,
      this.gOODSCODE,
      this.gOODSNAME,
      this.cUSTPRICE,
      this.sALEPRICE,
      this.fREIGHT,
      this.cATEGORYCODE,
      this.cATEGORYNAME,
      this.sTATUS,
      this.sTOCK,
      this.iMAGE});

  GoodsModel.fromJson(Map<String, dynamic> json) {
    nUM = json['NUM'];
    gOODSCODE = json['GOODS_CODE'];
    gOODSNAME = json['GOODS_NAME'];
    cUSTPRICE = json['CUST_PRICE'];
    sALEPRICE = json['SALE_PRICE'];
    fREIGHT = json['FREIGHT'];
    cATEGORYCODE = json['CATEGORY_CODE'];
    cATEGORYNAME = json['CATEGORY_NAME'];
    sTATUS = json['STATUS'];
    sTOCK = json['STOCK'];
    iMAGE = json['IMAGE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NUM'] = this.nUM;
    data['GOODS_CODE'] = this.gOODSCODE;
    data['GOODS_NAME'] = this.gOODSNAME;
    data['CUST_PRICE'] = this.cUSTPRICE;
    data['SALE_PRICE'] = this.sALEPRICE;
    data['FREIGHT'] = this.fREIGHT;
    data['CATEGORY_CODE'] = this.cATEGORYCODE;
    data['CATEGORY_NAME'] = this.cATEGORYNAME;
    data['STATUS'] = this.sTATUS;
    data['STOCK'] = this.sTOCK;
    data['IMAGE'] = this.iMAGE;
    return data;
  }
}

