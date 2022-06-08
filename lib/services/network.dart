// ignore: import_of_legacy_library_into_null_safe
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imanhour/routes/index.dart';
import 'package:imanhour/widgets/network_error_item.dart';
// import 'package:imanhour/widgets/network_error_item.dart';

class NetworkStatusService extends GetxService {
  NetworkStatusService() {
    DataConnectionChecker().onStatusChange.listen(
      (status) async {
        _getNetworkStatus(status);
      },
    );
  }

  void _getNetworkStatus(DataConnectionStatus status) {
    if (status == DataConnectionStatus.connected) {
      print('CO  internet');
      const SnackBar(content: Text('Connecting internet ...'));
      _validateSession(); //after internet connected it will redirect to home page
    } else {
      print('no internet');
      const SnackBar(content: Text('No internet'));
      // Navigator.pushNamedAndRemoveUntil(
      //     , '/login', ModalRoute.withName('/login'));
      // Get.dialog(const NetworkErrorItem(),
      //     useSafeArea:
      //         false); // If internet loss then it will show the NetworkErrorItem widget
      // print('show network');
    }
  }

  void _validateSession() {
    Get.offNamedUntil(
        AppRoutes.time, (_) => false); //Here redirecting to list time page
    print('show list');
  }
}
