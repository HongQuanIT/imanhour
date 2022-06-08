// ignore_for_file: unnecessary_const

// ignore: unused_import
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'package:imanhour/api/api.dart' show Network;
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:cool_alert/cool_alert.dart';

class ManhourPage extends StatefulWidget {
  const ManhourPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ManhourPageState createState() => _ManhourPageState();
}

class _ManhourPageState extends State<ManhourPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _userName;
  late String _firstName;
  late String _id;
  // var user= {};
  @override
  void initState() {
    super.initState();
    _loadUserInfo().whenComplete(() {
      if (kDebugMode) {
        // print('ok nek');
      }
      setState(() {});
    });
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // user = <String, String> prefs.get('user');
    _userName = (prefs.getString('UserName') ?? "");
    _firstName = (prefs.getString('UserFirstName') ?? "");
    _id = (prefs.getString('UserId') ?? "");
  }

  void showInSnackBar(String value) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(value)));
  }

  void _handleFinger() async {
    EasyLoading.show(status: 'loading...');
    DateTime now = DateTime.now();
    String checkDate = DateFormat('y-M-d').format(now);
    String hour = DateFormat('kk').format(now);
    String minute = DateFormat('mm').format(now);
    if (kDebugMode) {
      print('checkdate : ' + checkDate);
      print('hour : ' + hour);
      print('minute : ' + minute);
    }
    var data = {"Hour": hour, "Minute": minute, "CheckDate": checkDate};
    try {
      var res = await Network().postData(data, '/Checkout/insert');

      var body = json.decode(res.body);

      if (body['status'] == 200) {
        EasyLoading.dismiss();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: 'Nhập giờ thành công!',
          onConfirmBtnTap: () => {
            Navigator.pushNamedAndRemoveUntil(
                context, '/time', (route) => false)
            // Navigator.popUntil(context, ModalRoute.withName('/time'))
            // Navigator.pushNamedAndRemoveUntil(
            //     context, '/time', ModalRoute.withName('/time'))
          },
          // autoCloseDuration: const Duration(seconds: 2),
        );
      } else {
        EasyLoading.dismiss();
        print(body['message']);
        showInSnackBar(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print('catch :(((');
        print(e.toString());
      }
      showInSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Manhour"),
      ),
      body: Container(
          color: const Color.fromARGB(255, 245, 242, 243),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[_buildFinger()],
              ),
            ],
          )),
    );
  }

  Widget _buildFinger() {
    return Center(
      child: Container(
          margin: const EdgeInsets.only(top: 0),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  ButtonBar(
                    children: [
                      GestureDetector(
                        onTap: _handleFinger,
                        child: const Card(
                          child: Icon(
                            Icons.fingerprint,
                            size: 200,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text("Hello : " + _firstName),
                  Text("ID : " + _id),
                  Text("UserName : " + _userName),
                ],
              ),
            ],
          )),
    );
  }
}
