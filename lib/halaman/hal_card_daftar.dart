import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardDaftar extends StatefulWidget {
  final String noRM, nama, qrCode;
  CardDaftar({
    this.noRM,
    this.nama,
    this.qrCode,
  });

  @override
  _CardDaftarState createState() => _CardDaftarState();
}

class _CardDaftarState extends State<CardDaftar> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: mediaQueryData.size.height,
                    height: mediaQueryData.size.height * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent[700],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(mediaQueryData.size.height * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            _logo(),
                            _text(),
                          ],
                        ),
                        Row(
                          children: [
                            _qrCode(),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: mediaQueryData.size.width * 0.03),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _nama(),
                                  Row(
                                    children: [
                                      _text2(),
                                      _logoberhasil(),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        _text3(),
                        _noRM(),
                        _loginButton(),
                        _nama(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      child: Image.asset(
        "assets/images/logoputih.png",
        width: mediaQueryData.size.width * 0.05,
        height: mediaQueryData.size.height * 0.05,
      ),
    );
  }

  Widget _logoberhasil() {
    return IconButton(
      padding: EdgeInsets.all(15.0),
      icon: Icon(Icons.check_circle),
      color: Colors.white,
      iconSize: 20.0,
      onPressed: () {},
    );
  }

  Widget title() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              '${widget.noRM}',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
          )
        ],
      ),
    );
  }

  Widget _text() {
    return Text(
      "  Klinik Medika",
      style: new TextStyle(
          fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Widget _nama() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.02),
      child: Text(
        "Hai, " + '${widget.nama}',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23.0),
      ),
    );
  }

  Widget _text2() {
    return Text(
      'Pendaftaran Sukses',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    );
  }

  Widget _text3() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.04),
      child: Text(
        'Lanjutkan login menggunakan user dan password Nomer RM di bawah ini',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 23.0,
        ),
      ),
    );
  }

  Widget _noRM() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.05),
      child: Container(
        height: mediaQueryData.size.height * 0.1,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0.0, 1.0),
                blurRadius: 10.0)
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // "0009 - 9998",
                '${widget.noRM}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.grey[800],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: mediaQueryData.size.height * 0.01),
                child: Card(
                  elevation: 0,
                  child: InkWell(
                    child: IconButton(
                      icon: Icon(
                        Icons.content_copy,
                        size: 30,
                      ),
                      color: Colors.grey[400],
                      onPressed: () async {
                        Clipboard.setData(
                          ClipboardData(text: '${widget.noRM}'),
                        );
                        print('${widget.noRM}');
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.04),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: mediaQueryData.size.height * 0.07,
        child: RaisedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/DaftarAdmin');
            // Navigator.of(context).pushReplacement(
            //   new MaterialPageRoute(
            //     builder: (context) => new DaftarAdmin(
            //       cusername: '${widget.noRM}',
            //       cpassword: '${widget.noRM}',
            //     ),
            //   ),
            // );
          },
          child: Text(
            'LOGIN',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          color: Colors.greenAccent[700],
          elevation: 0,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _qrCode() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      child: Image.network(
        '${widget.qrCode}',
        width: mediaQueryData.size.width * 0.2,
        height: mediaQueryData.size.height * 0.15,
      ),
    );
  }
}
