import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:antrian_dokter/data.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';

class InputLayanan extends StatefulWidget {
  @override
  _InputLayananState createState() => _InputLayananState();
}

class _InputLayananState extends State<InputLayanan> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focusNode = new FocusNode();
  bool _loading = false;
  String _statusLayanan;
  List _status = [
    {
      "id": '1',
      "status": 'Aktif',
    },
    {
      "id": '0',
      "status": 'Tidak Aktif',
    },
  ];
  TextEditingController nama = new TextEditingController();
  var alertStyle = AlertStyle(
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 16.0,
    ),
    animationDuration: Duration(milliseconds: 100),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.black,
    ),
    constraints: BoxConstraints.expand(width: 300),
    overlayColor: Color(0x55000000),
    alertElevation: 0,
    alertAlignment: Alignment.center,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _inputLayanan() async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    setState(
      () {
        _loading = true;
      },
    );
    Future.delayed(
      Duration(seconds: 3),
      () async {
        String theUrl = getMyUrl.url + 'layanan/inputdata';
        var res = await http.post(
          Uri.encodeFull(theUrl),
          headers: {"Accept": "application/json"},
          body: {
            "nama": nama.text,
            "status": _statusLayanan,
          },
        );
        var inputlayanan = json.decode(res.body);
        if (inputlayanan['Status'] == 'InputBerhasil') {
          setState(
            () {
              _loading = false;
            },
          );
          SnackBar snackBar = SnackBar(
            duration: Duration(seconds: 5),
            elevation: 6.0,
            behavior: SnackBarBehavior.floating,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.01,
                ),
                Text(
                  'Layanan Berhasil di Tambah',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'LIHAT',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/ListLayanan');
                print('Berhasil');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          nama.clear();
          setState(
            () {
              _statusLayanan = null;
            },
          );
          print(inputlayanan);
        } else {
          setState(
            () {
              _loading = false;
            },
          );
          SnackBar snackBar = SnackBar(
            duration: Duration(seconds: 5),
            elevation: 6.0,
            behavior: SnackBarBehavior.floating,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.error,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.01,
                ),
                Text(
                  'Layanan dokter gagal',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'GAGAL',
              textColor: Colors.white,
              onPressed: () {
                print('Gagal');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          print("Gagal");
          print(inputlayanan);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: Colors.blue[400],
        opacity: 0.5,
        progressIndicator: SpinKitWave(
          color: Colors.white,
          size: 50,
        ),
        child: Stack(
          children: <Widget>[
            Container(
              width: mediaQueryData.size.height,
              height: mediaQueryData.size.height * 0.4,
              decoration: BoxDecoration(
                color: Color(0xFF44AEA5),
              ),
              child: Column(
                children: <Widget>[
                  _formlayanan(),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: mediaQueryData.size.height * 0.02,
                  right: mediaQueryData.size.height * 0.02,
                  // bottom: mediaQueryData.size.height * 0.03,
                  // top: mediaQueryData.size.height * 0.001,
                ),
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      _inputNamaLayanan(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.03),
                      ),
                      _inputStatusLayanan(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.05),
                      ),
                      _loginButton(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.08),
                      ),
                      // _daftar(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _formlayanan() {
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
            "Form layanan",
            style: new TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _inputNamaLayanan() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        focusNode: _focusNode,
        controller: nama,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Nama Layanan',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.event_available,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputStatusLayanan() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(
          top: mediaQueryData.size.height * 0.005,
          left: mediaQueryData.size.height * 0.01,
          right: mediaQueryData.size.height * 0.02),
      height: mediaQueryData.size.height * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        underline: SizedBox(),
        hint: Row(
          children: <Widget>[
            SizedBox(
              width: mediaQueryData.size.width * 0.01,
            ),
            Icon(
              Icons.swap_horizontal_circle,
              color: Colors.grey,
            ),
            Text(
              "    Pilih Status",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
        isExpanded: true,
        items: _status.map(
          (item) {
            return new DropdownMenuItem<String>(
              value: item['id'], // value yang di kirim
              child: new Text(item['status']), // UI dropdown. oke cak?oke
            );
          },
        ).toList(),
        onChanged: (newVal) {
          setState(
            () {
              _statusLayanan = newVal;
            },
          );
        },
        value: _statusLayanan,
      ),
    );
  }

  Widget _loginButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: mediaQueryData.size.height * 0.07,
      child: RaisedButton(
        onPressed: () async {
          _focusNode.unfocus();
          if (nama.text == null || nama.text == '') {
            SnackBar snackBar = SnackBar(
              duration: Duration(seconds: 5),
              elevation: 6.0,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.width * 0.01,
                  ),
                  Text(
                    ' Nama belum diisi',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('ULANGI');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
          } else if (_statusLayanan == null || _statusLayanan == '') {
            SnackBar snackBar = SnackBar(
              duration: Duration(seconds: 5),
              elevation: 6.0,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.width * 0.01,
                  ),
                  Text(
                    ' Status belum diisi',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('ULANGI');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
          } else {
            _inputLayanan();
          }
        },
        child: Text(
          'TAMBAH LAYANAN',
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

  // Widget _daftar() {
  //   return Container(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Text("Belum punya akun?"),
  //         GestureDetector(
  //           onTap: () {
  //             _focusNode.unfocus();
  //             // Navigator.pushNamed(context, '/HalPilihAKun');
  //             // nama.clear();
  //             // setState(() {
  //             //   _statusLayanan = null;
  //             // });
  //           },
  //           child: Text(
  //             "  Daftar",
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
