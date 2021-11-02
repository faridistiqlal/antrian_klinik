import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:antrian_dokter/data.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahOrtu extends StatefulWidget {
  @override
  _TambahOrtuState createState() => _TambahOrtuState();
}

class _TambahOrtuState extends State<TambahOrtu> {
  // String _mySelection;
  bool _loading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final format = DateFormat("yyyy-MM-dd");
  TextEditingController cKK = new TextEditingController();
  TextEditingController cAyah = new TextEditingController();
  TextEditingController cTtlAyah = new TextEditingController();
  TextEditingController cIbu = new TextEditingController();
  TextEditingController cTtlIbu = new TextEditingController();
  TextEditingController cAlamat = new TextEditingController();
  TextEditingController cHp = new TextEditingController();

  var data;
  String kk = '';
  String ayah = '';
  String ttlayah = '';
  String ibu = '';
  String ttlibu = '';
  String alamat = '';
  String hp = '';

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

  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String theUrl = getMyUrl.url + 'Pasien/GetDataBlmMenikah';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
      body: {
        "NoRm": pref.getString("Username"),
      },
    );
    data = json.decode(res.body);
    this.setState(
      () {
        kk = data['NoKK'];
        ayah = data['Ayah'];
        ttlayah = data['TtlAyah'];
        ibu = data['Ibu'];
        ttlibu = data['TtlIbu'];
        alamat = data['Alamat'];
        hp = data['Hp'];

        cKK = new TextEditingController(text: kk);
        cAyah = new TextEditingController(text: ayah);
        cTtlAyah = new TextEditingController(text: ttlayah);
        cIbu = new TextEditingController(text: ibu);
        cTtlIbu = new TextEditingController(text: ttlibu);
      },
    );
    print(data);
  }

  void tambahOrtu() async {
    // setState(
    //   () {
    //     _loading = true;
    //   },
    // );
    String theUrl = getMyUrl.url + 'pasien/tambahortu';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
      body: {
        "kk": kk,
        "ayah": ayah,
        "ttlayah": ttlayah,
        "ibu": ibu,
        "ttlibu": ttlibu,
        // "kelamin": _mySelection,
        "alamat": alamat,
        "hp": hp,
      },
    );
    var responsBody = json.decode(res.body);
    if (responsBody['Status'] == 'InputBerhasil') {
      Alert(
        context: context,
        title: "Berhasil",
        desc: "Silahkan lihat data keluarga",
        type: AlertType.success,
        style: alertStyle,
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.orange,
            radius: BorderRadius.circular(15.0),
          ),
        ],
      ).show();
    } else if (responsBody['Status'] == 'OrtuSudahAda') {
      Alert(
        context: context,
        title: "Peringatan",
        desc: "Orang Tua Sudah Terdaftar Sebelumnya",
        type: AlertType.warning,
        style: alertStyle,
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.orange,
            radius: BorderRadius.circular(15.0),
          ),
        ],
      ).show();
    } else {
      Alert(
        context: context,
        title: "Gagal",
        desc: "Silahkan Cek Kembali data anda",
        type: AlertType.error,
        style: alertStyle,
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.orange,
            radius: BorderRadius.circular(15.0),
          ),
        ],
      ).show();
      print('Gagal');
    }
    print(responsBody);
    return responsBody;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        key: scaffoldKey,
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          opacity: 0.5,
          color: Colors.blueAccent[100],
          progressIndicator: CircularProgressIndicator(
            backgroundColor: Colors.red,
          ),
          child: Stack(
            children: <Widget>[
              _logo(),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: mediaQueryData.size.height * 0.02,
                    right: mediaQueryData.size.height * 0.02,
                    bottom: mediaQueryData.size.height * 0.02,
                    top: mediaQueryData.size.height * 0.001,
                  ),
                  child: ListView(
                    children: <Widget>[
                      _text(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.03),
                      ),
                      _inputKK(),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.02,
                      ),
                      _inputAyah(),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.02,
                      ),
                      _inputTtlAyah(),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.02,
                      ),
                      _inputIbu(),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.02,
                      ),
                      _inputTtlIbu(),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.02,
                      ),
                      Text(
                        "Edit Data Jika Masih Kosong Atau Salah",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.02,
                      ),
                      _loginButton(),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.04,
                      ),
                      _daftar(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _text() {
    return Text(
      "Tambah Member Orangtua",
      style: new TextStyle(
          fontSize: 25.0, color: Colors.grey[800], fontWeight: FontWeight.bold),
    );
  }

  Widget _logo() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              "assets/images/daftar.png",
            ),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter),
      ),
    );
  }

  Widget _inputKK() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: cKK,
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
          hintText: 'KK',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.credit_card,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputAyah() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: cAyah,
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
          hintText: 'Ayah',
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

  Widget _inputTtlAyah() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: cTtlAyah,
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
          hintText: 'TTL Ayah',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.location_city,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputIbu() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: cIbu,
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
          hintText: 'Ibu',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.group_add,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputTtlIbu() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: cTtlIbu,
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
          hintText: 'TTL Ibu',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.group_add,
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
          // if (cKK.text == null || cKK.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'NIK Wajib di Isi',
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
          // } else if (cKK.text == null || cKK.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'KK wajib di isi',
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
          // } else if (cAyah.text == null || cAyah.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Ayah Wajib di Isi',
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
          // } else if (cTtlAyah.text == null || cTtlAyah.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Tempat Wajib di Isi',
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
          // else if (cTglAyah.text == null || cTglAyah.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Tanggal Wajib di Isi',
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
          // else if (cIbu.text == null || cIbu.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Tanggal Wajib di Isi',
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
          // } else if (cTtlIbu.text == null || cTtlIbu.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Tempat Wajib di Isi',
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
          // } else if (cTglIbu.text == null || cTglIbu.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Tanggal Wajib di Isi',
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
          // } else if (cAlamat.text == null || cAlamat.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Alamat Wajib di Isi',
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
          // } else if (cHp.text == null || cHp.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Telepon Wajib di Isi',
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
          // } else {
          tambahOrtu();
          //}
        },
        child: Text(
          'Daftar',
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

  Widget _daftar() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Kesulitan mengisi?"),
          SizedBox(
            width: mediaQueryData.size.width * 0.01,
          ),
          GestureDetector(
            onTap: () {
              //inputPasienMenikah();
              //Navigator.pushNamed(context, '/CardDaftar');
            },
            child: Text(
              "Bantuan",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent[100],
              ),
            ),
          )
        ],
      ),
    );
  }
}
