// ignore_for_file: unnecessary_const

// import 'dart:html';

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:imanhour/api/api.dart' show Network;
import 'package:imanhour/screens/manhour.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class TimePage extends StatefulWidget {
  const TimePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  // late String _userName;
  // late String _firstName;
  // late String _id;
  bool isLoading = false;
  List<dynamic> newListData = [];
  List<dynamic> listData = [];
  // var user= {};
  @override
  void initState() {
    super.initState();
    getData();
    _loadUserInfo().whenComplete(() {
      // if (kDebugMode) {
      //   print('Hello ' + _userName);
      // }
      setState(() {});
    });
  }

  fetchApi() async {
    try {
      // setState(() {
      //   isLoading = true;
      // });
      EasyLoading.show(status: 'loading...');
      DateTime now = DateTime.now();
      String checkDate = DateFormat('y-MM-d').format(now);
      print('/Checkout/Time?day=' + checkDate);
      var res = await Network().getData('/Checkout/Time?day=' + checkDate);
      print('res');
      print(res.body);
      var body = json.decode(res.body);

      if (body['status'] == 200) {
        print(body['data']);
        listData = body['data'];

        // setState(() {
        //   isLoading = false;
        // });
      } else {
        if (kDebugMode) {
          print(body['message']);
        }
      }
      EasyLoading.dismiss();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  getData() async {
    await fetchApi();
    print('list time data');
    print(listData);
    List<dynamic> newListData = [];
    // ignore: avoid_function_literals_in_foreach_calls
    listData.forEach((element) {
      // print(element['Start'].toString().trim());
      if (element['Id'].toString() == "0") {
        element['type'] = 1; // thoi gian moi bat dau
        newListData.add(element);
      } else if ((element['Id'].toString() == "-4" ||
              element['Id'].toString() == "-1") &&
          element['Total'].toString() != "00:00") {
        element['type'] = 2; // khoang thoi gian nghi
        newListData.add(element);
      } else if (int.parse(element['Id'].toString()) > 1) {
        element['type'] = 3; // nhap cong viec
        element['Tache'] = element['BriefName'] + " / " + element['Tache'];
        newListData.add(element);
      } else if (element['Total'].toString() != "00:00") {
        element['type'] = 1;
        newListData.add(element);
      }
    });
    setState(() {
      this.newListData = newListData;
    });
  }

  _formatTime(s) {
    List arr = s.split(':');
    if (arr[0].length == 1) {
      arr[0] = "0" + arr[0];
    }
    if (arr[1].length == 1) {
      arr[1] = "0" + arr[1];
    }
    return arr[0] + ":" + arr[1];
  }

  _loadUserInfo() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // user = <String, String> prefs.get('user');
    // _userName = (prefs.getString('UserName') ?? "");
    // _firstName = (prefs.getString('UserFirstName') ?? "");
    // _id = (prefs.getString('UserId') ?? "");
  }

  void _handleLogout() async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want Logout?'),
        actions: <Widget>[
          GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async => {
              localstorage.remove("token"),
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', ModalRoute.withName('/login')),
            },
            child: const Text("Yes, Logout"),
          ),
        ],
      ),
    );
  }

  //  ign ore: non_constant_identifier_names
  WarningOutApp(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit imanhour App?'),
        actions: <Widget>[
          GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: const Text("NO"),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: const Text("YES"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return await WarningOutApp(context);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("List time manhour"),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: getData,
                    child: const Icon(
                      Icons.refresh,
                      size: 26.0,
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: _handleLogout,
                    child: const Icon(Icons.logout),
                  )),
            ],
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  color: const Color.fromARGB(255, 245, 242, 243),
                  child: SizedBox(
                    // height: 200, // constrain height
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      shrinkWrap: true,
                      itemCount: newListData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return listItem(
                            newListData[index]["Total"],
                            newListData[index]["Start"],
                            newListData[index]["End"],
                            newListData[index]["Tache"],
                            newListData[index]["type"]);
                      },
                    ),
                  )),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ManhourPage(
                          title: 'Manhour',
                        )),
              );
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.fingerprint_sharp),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }

  Widget listItem(
      String total, String start, String end, String tache, int type) {
    return Card(
      child: Row(
        children: <Widget>[
          Container(
              color: type == 3
                  ? Colors.green
                  : (type == 1 ? Colors.grey : Colors.black),
              width: MediaQuery.of(context).size.width * 0.20,
              margin: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer, color: Colors.white),
                  Text(
                    _formatTime(total),
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              )),
          Container(
            height: 20,
            width: 1,
            color: Colors.blue,
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.70,
              margin: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 10,
                    child: Column(
                      children: [
                        Text(tache),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            start,
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          Text(end,
                              style: const TextStyle(
                                fontSize: 10,
                              )),
                        ],
                      )),
                ],
              )),
        ],
      ),
    );
  }
}
