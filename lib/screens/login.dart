import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imanhour/api/api.dart' show Network;
import 'package:imanhour/api/local_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // bool _autovalidate = false;
  late String _email, _password;
  bool isLoading = false;

  final GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();

  void showInSnackBar(String value) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(value)));
  }

  void _handleLogin() async {
    final FormState? form = _formKeyLogin.currentState;
    if (!form!.validate()) {
      // _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please check validate before submitting.');
    } else {
      form.save();
      if (kDebugMode) {
        print('login');
      }
      var data = {'UserName': _email, 'UserPassword': _password};
      try {
        print('vo try');
        setState(() {
          isLoading = true;
        });
        var res = await Network().authData(data, '/User/Login');

        print(res.body);
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
          setState(() {
            isLoading = false;
          });
          showInSnackBar(body['message']);
        }
      } catch (e) {
        print('vo catch');
        if (kDebugMode) {
          print('catch :(((');
          print(e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: _formKeyLogin,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          key: const Key("_mobile"),
                          decoration: const InputDecoration(labelText: "Email"),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) {
                            _email = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: "Password"),
                          obscureText: true,
                          onSaved: (value) {
                            _password = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        ButtonBar(
                          children: <Widget>[
                            ElevatedButton.icon(
                                onPressed: () {
                                  print('heheheeh');
                                  _handleLogin();
                                },
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('Sign in')),
                          ],
                        ),
                        // buildAvailability(context),
                        const SizedBox(height: 24),
                        buildAuthenticate(context),
                      ],
                    ),
                  ),
                ),
        ));
  }

  Widget buildAvailability(BuildContext context) => buildButton(
        text: 'Check Availability',
        icon: Icons.event_available,
        onClicked: () async {
          final isAvailable = await LocalAuthApi.hasBiometrics();
          final biometrics = await LocalAuthApi.getBiometrics();

          final hasFingerprint = biometrics.contains(BiometricType.fingerprint);

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Availability'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildText('Biometrics', isAvailable),
                  buildText('Fingerprint', hasFingerprint),
                ],
              ),
            ),
          );
        },
      );

  Widget buildText(String text, bool checked) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            checked
                ? const Icon(Icons.check, color: Colors.green, size: 24)
                : const Icon(Icons.close, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(fontSize: 24)),
          ],
        ),
      );

  Widget buildAuthenticate(BuildContext context) => buildButton(
        text: 'Authenticate Finger',
        icon: Icons.fingerprint_rounded,
        onClicked: () async {
          print('press authenticate');
          final isAuthenticated = await LocalAuthApi.authenticate();

          if (isAuthenticated) {
            SharedPreferences localStorage =
                await SharedPreferences.getInstance();
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
              setState(() {
                isLoading = true;
              });
              var res = await Network().authData(data, '/User/Login');

              print(res.body);
              var body = json.decode(res.body);

              if (body['status'] == 200) {
                localStorage.setString('UserPassword', _password);
                localStorage.setString('token', body['token']);
                localStorage.setString('UserName', body['data']['UserName']);
                localStorage.setString(
                    'UserId', json.encode(body['data']['UserId']));
                localStorage.setString('UserFirstName',
                    json.encode(body['data']['UserDes']['UserFirstName']));
                Navigator.pushNamedAndRemoveUntil(
                    context, '/time', ModalRoute.withName('/time'));
              } else {
                setState(() {
                  isLoading = false;
                });
                showInSnackBar(body['message']);
              }
            } catch (e) {
              if (kDebugMode) {
                print(e.toString());
              }
            }
          }
        },
      );

  Widget buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
        ),
        icon: Icon(icon, size: 26),
        label: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
        onPressed: onClicked,
      );
}
