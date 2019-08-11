import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spend_tracker/models/models.dart';

class Apis {
  static const String server = 'https://www.googleapis.com';
  static const String key = 'AIzaSyD2vHGYh4oFxonSYAf_Ct6HxKlHPVP4440';
  static const String database = 'https://firestore.googleapis.com/v1';
  static const String documents =
      'projects/spendtracker-3e139/databases/(default)/documents';

  String _securityToken;

  Future<List<Account>> getAccounts() async {
    final url = '$database/$documents/account';
    var response = await http.get(url, headers: _createHeader());
    _checkStatus(response);
    return Account.fromJson(response.body);
  }

  Future createAccount(Account account) async {
    final url = '$database/$documents/account';

    var response = await http.post(
      url,
      headers: _createHeader(),
      body: account.toJson(),
    );
    _checkStatus(response);
  }

  Future updateAccount(Account account) async {
    final url = '$database/${account.urlId}';

    var response = await http.patch(
      url,
      headers: _createHeader(),
      body: account.toJson(),
    );
    _checkStatus(response);
  }

  Future<List<ItemType>> getTypes() async {
    final url = '$database/$documents/type';
    var response = await http.get(url, headers: _createHeader());
    _checkStatus(response);
    return ItemType.fromJson(response.body);
  }

  Future createType(ItemType type) async {
    final url = '$database/$documents/type';
    var response = await http.post(
      url,
      headers: _createHeader(),
      body: type.toJson(),
    );
    _checkStatus(response);
  }

  Future updateType(ItemType type) async {
    final url = '$database/${type.urlId}';
    var response = await http.patch(
      url,
      headers: _createHeader(),
      body: type.toJson(),
    );
    _checkStatus(response);
  }

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

    _checkStatus(response);

    var map = json.decode(response.body);
    _securityToken = LoginResponse.fromMap(map).idToken;
  }

  void _checkStatus(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode} ${response.body}');
    }
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
