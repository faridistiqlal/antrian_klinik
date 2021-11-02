import 'package:antrian_dokter/halaman/hal_login.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(
      duration,
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return DaftarAdmin();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      body: Container(
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding:
                    new EdgeInsets.only(top: mediaQueryData.size.height * 0.3),
              ),
              Image.asset(
                "assets/images/logo2.png",
                width: mediaQueryData.size.width * 0.3,
                height: mediaQueryData.size.height * 0.3,
              ),
              new Text(
                "Klinik Medika",
                style: new TextStyle(
                  fontSize: 28.0,
                  color: Colors.grey,
                ),
              ),
              new Padding(
                padding:
                    new EdgeInsets.only(top: mediaQueryData.size.height * 0.3),
              ),
              new Text(
                "Versi 1.0",
                style: new TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
