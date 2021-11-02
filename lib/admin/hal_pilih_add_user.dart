import 'package:antrian_dokter/style/size_config.dart';
import 'package:flutter/material.dart';

class HalPilihUserAdmin extends StatefulWidget {
  @override
  _HalPilihUserAdminState createState() => _HalPilihUserAdminState();
}

class _HalPilihUserAdminState extends State<HalPilihUserAdmin> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            width: mediaQueryData.size.height,
            height: mediaQueryData.size.height * 0.4,
            decoration: BoxDecoration(
              color: Color(0xFF44AEA5),
            ),
            child: Column(
              children: <Widget>[
                _pilihuseradmin(),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(mediaQueryData.size.height * 0.02),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _admin(),
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

  Widget _pilihuseradmin() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.1,
        left: mediaQueryData.size.height * 0.04,
        right: mediaQueryData.size.height * 0.04,
        // bottom: mediaQueryData.size.height * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Pilih Tambah User",
            style: new TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _admin() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: mediaQueryData.size.height * 0.07,
      child: RaisedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/InputUser');
        },
        child: Text(
          'Admin',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Color(0xFF44AEA5),
        elevation: 0,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _berkerluarga() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: mediaQueryData.size.height * 0.07,
      child: RaisedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/HalPostKeluargaAdmin');
        },
        child: Text(
          'Berkeluarga',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Color(0xFF44AEA5),
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
          Navigator.pushNamed(context, '/HalPostBelumKeluargaAdmin');
        },
        child: Text(
          'Belum Berkerluarga',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Color(0xFF44AEA5),
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
