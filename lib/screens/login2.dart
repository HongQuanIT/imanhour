import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imanhour/common/background.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:imanhour/api/api.dart' show Network;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/local_auth.dart';

class Login2 extends StatefulWidget {
  const Login2({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isHidden = true;
  late String _email, _password;
  // bool obscure = true;
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  void _handleAuthFinger() async {
    print('press authenticate');
    final isAuthenticated = await LocalAuthApi.authenticate();

    if (isAuthenticated) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String? _email = (localStorage.getString("UserName") ?? "");
      String? _password = (localStorage.getString("UserPassword") ?? "");
      print(_email);
      print(_password);
      if (_email == "" || _password == "") {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text:
              'Authorize fail. Please login with username and password again!',
        );
        return;
      }
      var data = {'UserName': _email, 'UserPassword': _password};
      try {
        EasyLoading.show(status: 'loading...');
        var res = await Network().authData(data, '/User/Login');

        print(res.body);
        var body = json.decode(res.body);

        if (body['status'] == 200) {
          localStorage.setString('UserPassword', _password);
          localStorage.setString('token', body['token']);
          localStorage.setString('UserName', body['data']['UserName']);
          localStorage.setString('UserId', json.encode(body['data']['UserId']));
          localStorage.setString('UserFirstName',
              json.encode(body['data']['UserDes']['UserFirstName']));
          Navigator.pushNamedAndRemoveUntil(
              context, '/time', ModalRoute.withName('/time'));
        } else {
          EasyLoading.dismiss();
          showInSnackBar(body['message']);
        }
      } catch (e) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }

  void _handleLogin() async {
    final validate = validateInput();

    if (validate) {
      var data = {'UserName': _email, 'UserPassword': _password};
      try {
        EasyLoading.show(status: 'loading...');
        var res = await Network().authData(data, '/User/Login');

        var body = json.decode(res.body);

        if (body['status'] == 200) {
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.setString('token', body['token']);
          localStorage.setString('UserPassword', _password);
          localStorage.setString('UserName', body['data']['UserName']);
          localStorage.setString('UserId', json.encode(body['data']['UserId']));
          localStorage.setString('UserFirstName',
              json.encode(body['data']['UserDes']['UserFirstName']));
          Navigator.pushNamedAndRemoveUntil(
              context, '/time', ModalRoute.withName('/time'));
        } else {
          EasyLoading.dismiss();
          showInSnackBar(body['message']);
        }
      } catch (e) {
        EasyLoading.dismiss();
        print('vo catch');
        if (kDebugMode) {
          print('catch :(((');
          print(e.toString());
        }
      }
    }
  }

  bool validateInput() {
    bool flag = true;
    String text = "";
    if (_email.isEmpty) {
      text += 'Email is empty. ';
      flag = false;
    }
    if (_password.isEmpty) {
      text += 'Password is empty. ';
      flag = false;
    }

    if (!flag) {
      showInSnackBar(text);
      return false;
    }
    return true;
  }

  void showInSnackBar(String value) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(value)));
  }

  _togglePasswordView() {
    if (isHidden) {
      isHidden = false;
    } else {
      isHidden = true;
    }
    setState(() {
      isHidden = isHidden;
    });
    // if (kDebugMode) {
    //   print('ok bbbbb');
    // }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const colorizeColors = [
      Colors.red,
      Colors.purple,
      Colors.blue,
      Colors.grey,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 30.0,
      fontFamily: 'Helvetica',
    );
    return Scaffold(
      key: _scaffoldKey,
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText('LOGIN',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                      speed: const Duration(seconds: 2)),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
                totalRepeatCount: 10,
                onTap: () {
                  print("Tap Event");
                },
              ),
              SizedBox(height: size.height * 0.01),
              DefaultTextStyle(
                style: const TextStyle(
                    fontSize: 8.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText('LA FABRIQUE'),
                  ],
                  repeatForever: true,
                  isRepeatingAnimation: true,
                  totalRepeatCount: 10,
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ),
              SizedBox(height: size.height * 0.03),
              // SvgPicture.asset(
              //   "assets/images/logo_fabrique.svg",
              //   height: size.height * 0.35,
              // ),
              Image.asset(
                "assets/images/logo.PNG",
                width: size.width * 0.45,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(59, 244, 54, 54),
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextField(
                  onChanged: (value) {
                    _email = value;
                  },
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Colors.red,
                      ),
                      hintText: "Your Email",
                      // hintStyle:
                      //     TextStyle(color: Color.fromARGB(255, 70, 64, 64)),
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.white)),
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(59, 244, 54, 54),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          _password = value;
                        },
                        obscureText: isHidden,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: "Password",
                          icon: const Icon(
                            Icons.lock,
                            color: Colors.red,
                          ),
                          suffixIcon: InkWell(
                              onTap: _togglePasswordView,
                              child: Icon(
                                isHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              )),
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  )),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: ElevatedButton(
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        textStyle: const TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: ElevatedButton(
                    child: const Text(
                      "Authenticate Finger",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _handleAuthFinger,
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
