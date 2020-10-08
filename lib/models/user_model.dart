class UserModel {
  String name;
  String username;
  String password;
  double lat;
  double lng;

  UserModel({this.name, this.username, this.password, this.lat, this.lng});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    password = json['password'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['password'] = this.password;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

