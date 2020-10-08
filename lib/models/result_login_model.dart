class ResultLoginModel {
  bool status;
  Data data;

  ResultLoginModel({this.status, this.data});

  ResultLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String name;
  String username;
  double lat;
  double lng;
  String avatar;
  String token;

  Data(
      {this.id,
      this.name,
      this.username,
      this.lat,
      this.lng,
      this.avatar,
      this.token});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    lat = json['lat'];
    lng = json['lng'];
    avatar = json['avatar'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['avatar'] = this.avatar;
    data['token'] = this.token;
    return data;
  }
}

