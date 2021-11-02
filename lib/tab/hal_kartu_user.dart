import 'package:antrian_dokter/halaman/hal_gambar.dart';
import 'package:flutter/material.dart';
import 'package:antrian_dokter/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Kartu extends StatefulWidget {
  @override
  _KartuState createState() => _KartuState();
}

///KIM.2021.0018
///ndi lokasi seng gawe nampelke gambar?
///kui gambar.e by webservice opo asset cak?
///assets
///cek
///tak tampak cak
///rak ketok?
///orak
///
class _KartuState extends State<Kartu> {
  String qrCodeurl = '';
  String nama = "";
  String email = "";
  String hp = "";
  String kelamin = "";
  String alamat = "";
  String user = "";
  void initState() {
    super.initState();
    _qrcodeurl();
    _cekUser();
  }

  Future _cekUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("Status") != null) {
      setState(
        () {
          nama = pref.getString("Nama");
          email = pref.getString("Email");
          hp = pref.getString("Hp");
          kelamin = pref.getString("Kelamin");
          alamat = pref.getString("Alamat");
          user = pref.getString("Username");
        },
      );
    }
  }

  void _qrcodeurl() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(
      () {
        qrCodeurl = getMyUrl.urlQR + pref.getString("Username") + '.png';
      },
    );
    print(qrCodeurl);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   automaticallyImplyLeading: false,
        //   title: Text(
        //     'Kartu Anda',
        //     style: new TextStyle(
        //       fontSize: 20.0,
        //       color: Colors.white,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        //   centerTitle: true,
        // ),
        body: Stack(
      children: <Widget>[
        _logo(),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(mediaQueryData.size.height * 0.01),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text(),
                  _card(),
                  // _qrcode(), //sementara kene
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _card() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: mediaQueryData.size.height,
            height: mediaQueryData.size.height * 0.3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2167c1),
                  Color(0xFF0d6dc4),
                  Color(0xFF1686c7),
                  Color(0xFF2c94cd),
                ],
                stops: [0, 0.4, 0.7, 0.9],
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0.0, 5.0),
                    blurRadius: 10.0),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: _qrcode(),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _norm(),
                          _nama(),
                          _nomer(),
                          _email(),
                          _kelamin(),
                          // _alamat(),
                          // _status(),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Chip(
                              label: Text(
                                'Ketentuan',
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            new Text(
                              "1. Tunjukan selalu kartu ketika berobat",
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 11.0,
                              ),
                            ),
                            new Text(
                              "2. Kartu tidak boleh di salahgunakan",
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 11.0,
                              ),
                            ),
                            new Text(
                              "3. Apabila ada perubahan data bisa konsultasi ke klinik ",
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 11.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _text() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Text(
        "Kartu Anda",
        style: new TextStyle(
          fontSize: 25.0,
          color: Colors.grey[800],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _norm() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(
        //top: mediaQueryData.size.height * 0.01,
        left: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.02,
      ),
      child: Text(
        user,
        style: new TextStyle(
          fontSize: 21.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _kelamin() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(
        //top: mediaQueryData.size.height * 0.01,
        left: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.02,
      ),
      child: Text(
        'Kelamin : ' + kelamin,
        style: new TextStyle(
          fontSize: 13.0,
          color: Colors.blue[100],
          // fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _nama() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(
        //top: mediaQueryData.size.height * 0.01,
        left: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.02,
      ),
      child: Text(
        'Nama : ' + nama,
        style: new TextStyle(
          fontSize: 13.0,
          color: Colors.blue[100],
          //fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _email() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(
        //top: mediaQueryData.size.height * 0.01,
        left: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.02,
      ),
      child: Text(
        'Email : ' + email,
        style: new TextStyle(
          fontSize: 13.0,
          color: Colors.blue[100],
          //fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _alamat() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(
        //top: mediaQueryData.size.height * 0.01,
        left: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.02,
      ),
      child: Text(
        'Alamat : ' + alamat,
        style: new TextStyle(
          color: Colors.blue[100],
          fontSize: 12.0,
        ),
      ),
    );
  }

  Widget _nomer() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(
        //top: mediaQueryData.size.height * 0.01,
        left: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.02,
      ),
      child: Text(
        'Tlp : ' + hp,
        style: new TextStyle(
          fontSize: 13.0,
          color: Colors.blue[100],
          // fontWeight: FontWeight.bold,
        ),
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

  Widget _qrcode() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailGaleri(
              dGambar: "$qrCodeurl",
            ),
          ),
        );
      },
      child: Container(
        width: mediaQueryData.size.height * 0.13,
        height: mediaQueryData.size.height * 0.13,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0.0, 5.0),
                blurRadius: 10.0),
          ],
          image: DecorationImage(
            image: NetworkImage(
              "$qrCodeurl",
            ),
            fit: BoxFit.cover,
          ),
        ),

        // child: Image.network(
        //   "$qrCodeurl",
        // ),
        // alignment: Alignment.topCenter,
      ),
    );
  }
}
//image network po cak? iyo
//wait, pokok e seng load img seko urlrl
//oke done
//seng iki
