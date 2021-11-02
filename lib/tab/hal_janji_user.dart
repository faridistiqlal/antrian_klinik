import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:antrian_dokter/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Janji extends StatefulWidget {
  @override
  _JanjiState createState() => _JanjiState();
}

class _JanjiState extends State<Janji> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formatTime = DateFormat("HH:mm");
  final format = DateFormat("yyyy-MM-dd");
  List allDokter = List();
  List allLayanan = List();
  String cIdDokter;
  String cLayanan;
  bool _loading = false;
  String norm = "";
  TextEditingController cTglAktif = new TextEditingController();
  String iduser = "";
  @override
  void initState() {
    super.initState();
    _cekUser();
    //getDokter();
    getLayanan();
  }

  Future _cekUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("Status") != null) {
      setState(
        () {
          norm = pref.getString("Username");
          iduser = pref.getString("IdUser");
        },
      );
    }
  }

  void _addJanji() async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    setState(
      () {
        _loading = true;
      },
    );
    Future.delayed(
      Duration(seconds: 2),
      () async {
        String theUrl = getMyUrl.url + 'appoiment';
        var res = await http.post(
          Uri.encodeFull(theUrl),
          headers: {"Accept": "application/json"},
          body: {
            "IdLayanan": cLayanan,
            "IdDokter": cIdDokter,
            "NoRm": norm,
            "TanggalAppoiment": cTglAktif.text,
            "IdUser": iduser,
          },
        );
        var addJanji = json.decode(res.body);
        print(addJanji);
        if (addJanji['Status'] == 'Berhasil') {
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
                  'Janji Berhasil di Tambah',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'LIHAT',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/JanjiAKtif');
                print('Berhasil');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          setState(() {
            cLayanan = null;
            cIdDokter = null;
            // cTglAktif = null;
          });
          cTglAktif.clear();
        } else if (addJanji['Status'] == 'SudahDaftar') {
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
                  'Anda sudah mendaftar',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'LIHAT',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/JanjiAKtif');
                print('Berhasil');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);

          // print('gagal');
        } else if (addJanji['Status'] == 'Penuh') {
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
                  'Kuota Hari Sudah Penuh',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushReplacementNamed(context, '/JanjiAKtif');
                print('Berhasil');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          // print('gagal');
        } else if (addJanji['Status'] == 'Gagal') {
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
                  'Pendaftaran gagal',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushReplacementNamed(context, '/JanjiAKtif');
                print('Berhasil');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          // print('gagal');
        } else if (addJanji['Status'] == 'TanggalLewat') {
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
                  'Tanggal Lewat',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushReplacementNamed(context, '/JanjiAKtif');
                print('Berhasil');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          // print('gagal');
        } else if (addJanji['Status'] == 'SudahTutup') {
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
                  Icons.do_not_disturb,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.01,
                ),
                Text(
                  'Sudah Tutup',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushReplacementNamed(context, '/JanjiAKtif');
                print('Berhasil');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          // print('gagal');
        } else if (addJanji['Status'] == 'DokterLibur') {
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
                  Icons.directions_boat,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.01,
                ),
                Text(
                  'Dokter Libur',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushReplacementNamed(context, '/JanjiAKtif');
                print('Berhasil');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          // print('gagal');
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
                  Icons.check_circle,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.01,
                ),
                Text(
                  'Pendaftaran gagal',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushReplacementNamed(context, '/JanjiAKtif');
                print('Berhasil');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
        }

        // "Status": "DokterLibur"
        // "Status": "TanggalLewat"
        // "Status": "Berhasil",
        //  {Status: SudahDaftar}
        // Gagal
        //
        // Penuh
      },
    );
  }

  // Future getDokter() async {
  //   String theUrl = getMyUrl.url + 'Dokter/GetJadwalDokterAppoiment';
  //   var res = await http.get(
  //     Uri.encodeFull(theUrl),
  //     headers: {"Accept": "application/json"},
  //   );
  //   var iddokter = json.decode(res.body);
  //   print(iddokter);
  //   this.setState(
  //     () {
  //       allDokter = iddokter;
  //     },
  //   );
  // }

  Future getDokter(idLayanan) async {
    String theUrl =
        getMyUrl.url + 'Dokter/GetJadwalDokterAppoiment/' + idLayanan;
    var res = await http.get(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
    );
    var iddokter = json.decode(res.body);
    print(iddokter);
    if (this.mounted) {
      this.setState(
        () {
          allDokter = iddokter;
        },
      );
    }
  }

  Future<List> getList(idLayanan) async {
    String theUrl =
        getMyUrl.url + 'Dokter/GetJadwalDokterAppoiment/' + idLayanan;
    var res = await http.get(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
    );
    var jsonData = json.decode(res.body);
    if (this.mounted) {
      setState(
        () {
          allDokter = json.decode(res.body);
        },
      );
    }
    print(jsonData);
    return allDokter;
  }

  Future getLayanan() async {
    String theUrl = getMyUrl.url + 'Dokter/GetJadwalLayananAppoiment/';
    var res = await http.get(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
    );
    var layanan = json.decode(res.body);
    print(layanan);
    this.setState(
      () {
        allLayanan = layanan;
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
        // progressIndicator:
        // CircularProgressIndicator(backgroundColor: Colors.green),
        child: Stack(
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
                padding: EdgeInsets.all(mediaQueryData.size.height * 0.03),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _text(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.03),
                      ),
                      _inputLayanan(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.03),
                      ),
                      cLayanan != null
                          ? Flexible(
                              child: FutureBuilder(
                                future: getList(cLayanan),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) print(snapshot.error);
                                  return snapshot.hasData
                                      ? new Container(
                                          padding: EdgeInsets.only(
                                              top: mediaQueryData.size.height *
                                                  0.005,
                                              left: mediaQueryData.size.height *
                                                  0.01,
                                              right:
                                                  mediaQueryData.size.height *
                                                      0.02),
                                          height:
                                              mediaQueryData.size.height * 0.07,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey[50],
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: DropdownButton(
                                            underline: SizedBox(),
                                            hint: Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: mediaQueryData
                                                          .size.width *
                                                      0.01,
                                                ),
                                                Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                ),
                                                Text(
                                                  "    Pilih Dokter",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            isExpanded: true,
                                            items: allDokter.map(
                                              (item) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                      item['nama_dokter']),
                                                  value: item['id_dokter']
                                                      .toString(),
                                                );
                                              },
                                            ).toList(),
                                            onChanged: (newVal) {
                                              setState(
                                                () {
                                                  cIdDokter = newVal;
                                                },
                                              );
                                              // if (cLayanan != null) {
                                              //   setState(() {
                                              //     cLayanan = null;
                                              //   });
                                              // }
                                            },
                                            value: cIdDokter,
                                          ),
                                        )
                                      : new Container(
                                          child: _inputDokter(),
                                        );
                                },
                              ),
                            )
                          : Container(
                              padding: new EdgeInsets.only(
                                  top: mediaQueryData.size.height * 0.001),
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    _inputDokter(),
                                  ],
                                ),
                              ),
                            ),
                      //_inputDokter(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.03),
                      ),
                      _inputTglAktif(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.05),
                      ),
                      _loginButton(),
                      // _card(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _text() {
    return Text(
      "Buat janji",
      style: new TextStyle(
        fontSize: 25.0,
        color: Colors.grey[800],
        fontWeight: FontWeight.bold,
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

  Widget _inputDokter() {
    // MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        enabled: false,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Pilih Dokter',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputLayanan() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
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
      child: DropdownButton(
        underline: SizedBox(),
        hint: Row(
          children: <Widget>[
            SizedBox(
              width: mediaQueryData.size.width * 0.01,
            ),
            Icon(
              Icons.airline_seat_flat_angled,
              color: Colors.grey,
            ),
            Text(
              "    Pilih Layanan",
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        isExpanded: true,
        items: allLayanan.map(
          (item) {
            return new DropdownMenuItem(
              child: new Text(item['nama_layanan']),
              value: item['id_layanan'].toString(),
            );
          },
        ).toList(),
        onChanged: (newVal) {
          setState(
            () {
              cLayanan = newVal;
            },
          );
          if (cIdDokter != null) {
            setState(() {
              cIdDokter = null;
              //Navigator.pushReplacementNamed(context, '/Janji');
              cLayanan = newVal;
            });
          }
        },
        value: cLayanan,
      ),
    );
  }

  Widget _inputTglAktif() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: DateTimeField(
        controller: cTglAktif,
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100),
          );
        },
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Tanggal Appoiment',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.date_range,
            color: Colors.grey,
          ),
        ),
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
          // _focusNode.unfocus();
          //_addJanji();
          if (cIdDokter == null || cIdDokter == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Dokter Wajib di Isi',
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
          } else if (cLayanan == null || cLayanan == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Layanan belum di Isi',
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
          } else if (cTglAktif.text == null || cTglAktif.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Tanggal belum di Isi',
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
          } else {
            _addJanji();
          }
        },
        child: Text(
          'BUAT JANJI',
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
}
