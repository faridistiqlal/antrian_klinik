import 'package:antrian_dokter/style/size_config.dart';
import 'package:flutter/material.dart';

class HalPilihAKun extends StatefulWidget {
  @override
  _HalPilihAKunState createState() => _HalPilihAKunState();
}

class _HalPilihAKunState extends State<HalPilihAKun> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          _logo(),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.26),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(mediaQueryData.size.height * 0.04),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _text(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _berkerluarga(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _belumBerkerluarga(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.05),
                    ),
                    // _bantuan(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _logo() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              "assets/images/pilihakun.png",
            ),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter),
      ),
    );
  }

  Widget _text() {
    return Text(
      "Pilih status anda",
      style: new TextStyle(
          fontSize: 28.0, color: Colors.grey[800], fontWeight: FontWeight.bold),
    );
  }

  Widget _berkerluarga() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: mediaQueryData.size.height * 0.07,
      child: RaisedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Halkeluarga');
        },
        child: Text(
          'Berkeluarga',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Colors.blueAccent[100],
        elevation: 0,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _belumBerkerluarga() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: mediaQueryData.size.height * 0.07,
      child: RaisedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/HalBelumkeluarga');
        }, //since this is only a UI app
        child: Text(
          'Belum Berkerluarga',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Colors.blueAccent[100],
        elevation: 0,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Widget _bantuan() {
  //   return Container(
  //     width: SizeConfig.safeBlockHorizontal * 100,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Text("Apa status anda?"),
  //         SizedBox(
  //           width: SizeConfig.safeBlockVertical * 1,
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             Navigator.pushNamed(context, '/CardDaftar');
  //           },
  //           child: Text(
  //             "Bantuan",
  //             style: TextStyle(
  //               fontSize: 14.0,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.blueAccent[100],
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
