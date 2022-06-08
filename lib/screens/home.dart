import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _username;
  late String _token;
  // late String _firstname;

  @override
  void initState() {
    super.initState();
    _loadUserInfo().whenComplete(() {
      if (kDebugMode) {
        print('load user infor');
      }
      setState(() {});
    });
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = (prefs.getString('UserName') ?? "");
    // _firstname = (prefs.getString('UserFirstName') ?? "");
    _token = (prefs.getString('token') ?? "");
  }

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove("UserName");
    // prefs.remove("UserFirstName");
    prefs.remove("token");
    //Navigator.pushNamed(context, '/login');
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    if (_token == "") {
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('/login'));
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Row(
          // crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Welcome " + _username),
                // RaisedButton(    //khong duoc ho tro nua
                //   onPressed: _handleLogout,
                //   child: const Text("Logout"),
                // ),
                ElevatedButton(
                  onPressed: _handleLogout,
                  child: const Text("Logout"),
                ),
              ],
            )
          ],
        ));
  }
}
