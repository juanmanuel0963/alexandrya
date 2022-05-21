class LoginResponseModel {
  String? token;

  LoginResponseModel({this.token});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  LoginResponseModel.fromFake() {
    token = "QpwL5tke4Pnpja7X4";
  }
}
