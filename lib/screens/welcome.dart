import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Welcome> {
  String _token = "";

  @override
  void initState() {
    if (kDebugMode) {
      print('da vo');
    }
    super.initState();
    _loadUserInfo().whenComplete(() {
      if (kDebugMode) {
        print('ok nek');
      }
      setState(() {});
    });
  }

  _loadUserInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (kDebugMode) {
        print(prefs);
      }
      _token = (prefs.getString('token') ?? "");

      if (_token == "") {
        //Navigator.pushNamed(context, '/login');
        Navigator.pushNamedAndRemoveUntil(
            // context, '/time', ModalRoute.withName('/time'));
            context,
            '/login',
            ModalRoute.withName('/login'));
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/time', ModalRoute.withName('/time'));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
