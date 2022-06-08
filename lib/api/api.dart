import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/foundation.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imanhour/const/index.dart';

class Network {
  final String _url = AppConst.url;
  late var _token = '';

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token')!;
  }

  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    // print(fullUrl);
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        });
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    if (kDebugMode) {
      var a = "Bearer " + _token;
      print(a);
    }
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  _setHeaders() => <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer " + _token,
      };
}
