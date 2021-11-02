import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:antrian_dokter/data.dart';
import 'dart:async';

import 'package:rflutter_alert/rflutter_alert.dart';

class EditLayanan extends StatefulWidget {
  final String eNama, eStatus, eId;

  EditLayanan({this.eNama, this.eStatus, this.eId});
  @override
  _EditLayananState createState() => _EditLayananState();
}

class _EditLayananState extends State<EditLayanan> {
  FocusNode _focusNode = new FocusNode();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: unused_field
  bool _obscureText = true;
  // ignore: unused_field
  bool _loading = false;
  // ignore: unused_field
  bool _sudahlogin = false;
  String _statusLayanan;
  // TextEditingController nama = new TextEditingController();
  TextEditingController eNama = new TextEditingController();
  TextEditingController eStatus = new TextEditingController();
  TextEditingController eId = new TextEditingController();
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
    eNama = new TextEditingController(text: "${widget.eNama}");
    eStatus = new TextEditingController(text: "${widget.eStatus}");
    eId = new TextEditingController(text: "${widget.eId}");
    //nah pertanyaan.e nak data json.e tak tampilke neng form dropdown status------->
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
      Duration(seconds: 2),
      () async {
        String theUrl = getMyUrl.url + 'layanan/Editdata';
        if (_statusLayanan == null || _statusLayanan == '') {
          var res = await http.post(
            Uri.encodeFull(theUrl),
            headers: {"Accept": "application/json"},
            body: {
              "id": eId.text,
              "nama": eNama.text,
              "status": "${widget.eStatus}",
              //auto nonaktif
            },
          );
          var inputlayanan = json.decode(res.body);
          if (inputlayanan['Status'] == 'UpdateBerhasil') {
            setState(
              () {
                _loading = false;
              },
            );
            SnackBar snackBar = SnackBar(
              duration: Duration(seconds: 2),
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
                    'Layanan berhasil diedit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  print('Berhasil');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
            await Future.delayed(
              Duration(seconds: 2),
              () {
                Navigator.of(this.context).pushNamedAndRemoveUntil(
                    '/HalTabAdmin', ModalRoute.withName('/HalTabAdmin'));
              },
            );
            print(inputlayanan);
          } else if (inputlayanan['Status'] == 'UpdateGagal') {
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
                    'Layanan berhasil diedit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  print('Berhasil');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
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
                    'Layanan berhasil diedit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  print('Berhasil');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
            print(inputlayanan);
          }
        } else {
          var res = await http.post(
            Uri.encodeFull(theUrl),
            headers: {"Accept": "application/json"},
            body: {
              "id": eId.text,
              "nama": eNama.text,
              "status": _statusLayanan,
            },
          );
          var inputlayanan = json.decode(res.body);
          if (inputlayanan['Status'] == 'UpdateBerhasil') {
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
                    'Layanan berhasil diedit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  print('Berhasil');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
            await Future.delayed(
              Duration(seconds: 2),
              () {
                Navigator.of(this.context).pushNamedAndRemoveUntil(
                    '/HalTabAdmin', ModalRoute.withName('/HalTabAdmin'));
              },
            );
            print(inputlayanan);
          } else if (inputlayanan['Status'] == 'UpdateGagal') {
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
                    'Layanan Gagal diedit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  print('Berhasil');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
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
                    'Layanan Gagal diedit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  print('Berhasil');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
            print(inputlayanan);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
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
            // _logo(),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(mediaQueryData.size.height * 0.04),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // _text(),
                      // new Padding(
                      //   padding: new EdgeInsets.only(
                      //       top: mediaQueryData.size.height * 0.03),
                      // ),
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
                      //_daftar(),
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
            "Edit layanan",
            style: new TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          // IconButton(
          //   icon: Icon(
          //     Icons.credit_card,
          //     size: 30,
          //   ),
          //   color: Colors.white,
          //   onPressed: () async {},
          // )
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
        controller: eNama,
        focusNode: _focusNode,
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
          hintStyle: TextStyle(fontSize: 14),
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
              ),
            ),
          ],
        ),
        isExpanded: true,
        items: _status.map(
          (item) {
            return new DropdownMenuItem<String>(
              value: item['id'],
              child: new Text(item['status']),
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
          if (eNama.text == null || eNama.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Nama Wajib di Isi',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange[700],
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('ULANGI snackbar');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
          }
          // else if (_statusLayanan == null || _statusLayanan == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Status belum di Isi',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     backgroundColor: Colors.orange[700],
          //     action: SnackBarAction(
          //       label: 'ULANGI',
          //       textColor: Colors.white,
          //       onPressed: () {
          //         print('ULANGI snackbar');
          //       },
          //     ),
          //   );
          //   scaffoldKey.currentState.showSnackBar(snackBar);
          // }
          else {
            _inputLayanan();
          }
        },
        child: Text(
          'TAMBAH',
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
  //             Navigator.pushNamed(context, '/HalPilihAKun');
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
