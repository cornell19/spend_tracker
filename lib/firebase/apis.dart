import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spend_tracker/models/models.dart';

class Apis {
  static const String server = 'https://www.googleapis.com';
  static const String key = 'AIzaSyD2vHGYh4oFxonSYAf_Ct6HxKlHPVP4440';

  String _securityToken;

  Future login(String email, String password) async {
    final String url =
        '$server/identitytoolkit/v3/relyingparty/verifyPassword?key=$key';
    var response = await http.post(
      url,
      headers: _createHeader(),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Login failed');
    }

    var map = json.decode(response.body);
    _securityToken = LoginResponse.fromMap(map).idToken;
  }

  Map<String, String> _createHeader() {
    if (_securityToken != null) {
      var header = {
        "authorization": "Bearer $_securityToken",
        "Content-Type": "application/json"
      };
      return header;
    }

    return {"Content-Type": "application/json"};
  }
}
