import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imae_fetcher_flutter_app/imagesui.dart';
import 'package:connectivity/connectivity.dart';

void main() =>
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  StreamSubscription _streamSubscription;
  ConnectivityResult previous;

  void initState() {
    super.initState();
    try {
      InternetAddress.lookup("google.com").then((value) {
        if (value.isNotEmpty && value[0].rawAddress.isNotEmpty) {
          //internet connection available
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => imageui()));
        } else {
          //Not internet connection available
          _showDialog();
        }
      }).catchError((onError){
        //no connection
        _showDialog();
      });
    } on SocketException catch (_) {
      //no connection
      _showDialog();
    }

    Connectivity().onConnectivityChanged.listen((ConnectivityResult connectresult) {
      if(connectresult == ConnectivityResult.none){

      }else if(previous == ConnectivityResult.none){
        //internet connection
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => imageui()));
      }
      previous = connectresult;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text("No Internet Connection Detected"),
        actions: [
          FlatButton(
              onPressed: ()=> SystemChannels.platform.invokeMethod('Systemnavigator.pop'),
              child: Text("Exit"),
          ),
        ],
      ),
    );
  }

  void dispose(){
    super.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.only(top: 120),
              child: Text("Checking Your Internet Connectivity"),
            ),
          ],
        ),
      ),
    );
  }
}
