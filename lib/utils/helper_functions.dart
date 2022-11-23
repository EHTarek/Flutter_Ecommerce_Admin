import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getFormattedDate(DateTime dateTime, {String pattern = 'dd/MM/yyyy'}) {
  return DateFormat(pattern).format(dateTime);
}
void showMsg(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));


Future<bool> isConnectedToInternet() async{
  var result = await (Connectivity().checkConnectivity());
  return result == ConnectivityResult.wifi || result == ConnectivityResult.mobile;
}