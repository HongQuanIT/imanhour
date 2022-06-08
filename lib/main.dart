// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:async';
// import 'package:flutter/rendering.dart';
// import 'package:imanhour/screens/login.dart';
import 'package:imanhour/screens/login2.dart';
import 'package:imanhour/screens/home.dart';
import 'package:imanhour/screens/manhour.dart';
import 'package:imanhour/screens/time.dart';
import 'package:imanhour/screens/welcome.dart';
import 'package:imanhour/routes/index.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imanhour/services/network.dart';

// void main() => runApp(const MyApp());
Future<void> main() async {
  // debugPaintSizeEnabled = true; // paint layout to debug
  // try {
  //   final result = await InternetAddress.lookup('fbrk3.itsabeautifulday.fr');
  //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //     print('connected');
  //   }
  // } on SocketException catch (_) {
  //   print('not connected');
  // }
  runApp(const MyApp());
  // print('check internet');
  Get.put<NetworkStatusService>(NetworkStatusService(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Manhour',
      home: const Welcome(),
      routes: {
        // '/': (context) => const Welcome(),
        AppRoutes.login: (context) => const Login2(),
        AppRoutes.home: (context) => const MyHomePage(title: 'Home'),
        AppRoutes.manhour: (context) => const ManhourPage(title: 'Manhour'),
        AppRoutes.time: (context) => const TimePage(title: 'Check Times'),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      builder: EasyLoading.init(),
    );
  }
}
