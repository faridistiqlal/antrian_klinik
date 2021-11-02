import 'package:antrian_dokter/halaman/hal_card_daftar.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:antrian_dokter/data.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HalBelumkeluarga extends StatefulWidget {
  @override
  _HalBelumkeluargaState createState() => _HalBelumkeluargaState();
}

class _HalBelumkeluargaState extends State<HalBelumkeluarga> {
  String _mySelection2;
  bool _loading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final format = DateFormat("yyyy-MM-dd");
  TextEditingController cKK = new TextEditingController();
  TextEditingController cNama = new TextEditingController();
  TextEditingController cTtl = new TextEditingController();
  TextEditingController cTgl = new TextEditingController();
  //TextEditingController cKelamin = new TextEditingController();
  TextEditingController cAlamat = new TextEditingController();
  TextEditingController cHp = new TextEditingController();
  TextEditingController cNamaAyah = new TextEditingController();
  TextEditingController cTtlAyah = new TextEditingController();
  TextEditingController cTglAyah = new TextEditingController();
  TextEditingController cNamaIbu = new TextEditingController();
  TextEditingController cTtlIbu = new TextEditingController();
  TextEditingController cTglIbu = new TextEditingController();
  TextEditingController cAnakke = new TextEditingController();
  List _status = [
    {
      "id": 'L',
      "status": 'Laki-Laki',
    },
    {
      "id": 'P',
      "status": 'Perempuan',
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

  void inputPasienBelumMenikah() async {
    setState(
      () {
        _loading = true;
      },
    );

    String theUrl = getMyUrl.url + 'pasien/inputpasienbelummenikah';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
      body: {
        "kk": cKK.text,
        "nama": cNama.text,
        "ttl": cTtl.text + ', ' + cTgl.text,
        "kelamin": _mySelection2,
        "alamat": cAlamat.text,
        "hp": cHp.text,
        "namaayah": cNamaAyah.text,
        "ttlayah": cTtlAyah.text + ', ' + cTglAyah.text,
        "namaibu": cNamaIbu.text,
        "ttlibu": cTtlIbu.text + ', ' + cTglIbu.text,
        "anakke": cAnakke.text,
      },
    );
    var responsBody = json.decode(res.body);

    if (responsBody['Status'] == 'InputBerhasil') {
      // if (this.mounted) {
      //   setState(
      //     () {
      //       _loading = false;
      //     },
      //   );
      // }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CardDaftar(
            noRM: responsBody['NoRM'],
            nama: responsBody['Nama'],
            qrCode: responsBody['QrCode'],
          ),
        ),
      );
      // Navigator.of(this.context).pushNamedAndRemoveUntil(
      //   '/DaftarAdmin',
      //   ModalRoute.withName('/DaftarAdmin'),
      // );
      print(responsBody);
    } else if (responsBody['Status'] == 'InputDataUserMenikahGagal') {
      print('Gagal 2');
      if (this.mounted) {
        setState(
          () {
            _loading = false;
          },
        );
      }
      Alert(
        context: context,
        title: "KK Sudah Terdaftar",
        desc: "Pastikan KK yang anda masukan sudah benar",
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
      if (this.mounted) {
        setState(
          () {
            _loading = false;
          },
        );
      }
      Alert(
        context: context,
        title: "Daftar Gagal",
        desc: "Mohon Ulangi Pendaftaran",
        type: AlertType.error,
        style: alertStyle,
        buttons: [
          DialogButton(
            child: Text(
              "ULANGI",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.red,
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
        progressIndicator: SpinKitWave(
          color: Colors.white,
          size: 50,
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
                    _inputNama(),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.02,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: _inputTtl(),
                        ),
                        SizedBox(
                          width: mediaQueryData.size.width * 0.01,
                        ),
                        Flexible(
                          child: _inputTgl(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.02,
                    ),
                    _inputKelamin(),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.02,
                    ),
                    _inputAlamat(),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.02,
                    ),
                    _inputNoTlp(),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.02,
                    ),
                    _inputAnakKe(),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.02,
                    ),
                    _inputNamaAyah(),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.02,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: _inputTtlAyah(),
                        ),
                        SizedBox(
                          width: mediaQueryData.size.width * 0.01,
                        ),
                        Flexible(
                          child: _inputTglAyah(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.02,
                    ),
                    _inputNamaIbu(),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.02,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: _inputTtlIbu(),
                        ),
                        SizedBox(
                          width: mediaQueryData.size.width * 0.01,
                        ),
                        Flexible(
                          child: _inputTglIbu(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.05,
                    ),
                    _loginButton(),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.04,
                    ),
                    // _daftar(),
                  ],
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
      "Form Belum Keluarga",
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
        controller: cKK,
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

  Widget _inputNama() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: cNama,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Nama',
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

  Widget _inputTtl() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: cTtl,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Tempat Lahir',
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

  Widget _inputTgl() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: DateTimeField(
        controller: cTgl,
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
          hintText: 'Tanggal Lahir',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _inputKelamin() {
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
              Icons.accessibility_new,
              color: Colors.grey,
            ),
            Text(
              "    Pilih Kelamin",
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
              _mySelection2 = newVal;
            },
          );
        },
        value: _mySelection2,
      ),
    );
  }

  Widget _inputAlamat() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: cAlamat,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Alamat',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.location_on,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputNoTlp() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: cHp,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Telepon',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.phone_android,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputNamaAyah() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: cNamaAyah,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Nama Ayah',
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
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Tempat',
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

  Widget _inputTglAyah() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: DateTimeField(
        controller: cTglAyah,
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
          hintText: 'Tanggal lahir Ayah',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _inputNamaIbu() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: cNamaIbu,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Nama Ibu',
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

  Widget _inputTtlIbu() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: cTtlIbu,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Tempat',
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

  Widget _inputTglIbu() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: DateTimeField(
        controller: cTglIbu,
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
          hintText: 'Tanggal Lahir Ibu',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _inputAnakKe() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: cAnakke,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Anak ke',
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
          if (cKK.text == null || cKK.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'KK Wajib di Isi',
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
          } else if (cNama.text == null || cNama.text == '') {
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
          } else if (cTtl.text == null || cTtl.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Tempat Wajib di Isi',
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
          } else if (cTgl.text == null || cTgl.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Tanggal Wajib di Isi',
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
          } else if (_mySelection2 == null || _mySelection2 == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Kelamin Wajib di Isi',
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
          } else if (cAlamat.text == null || cAlamat.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Alamat Wajib di Isi',
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
          } else if (cHp.text == null || cHp.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Telepon Wajib di Isi',
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
          } else if (cNamaAyah.text == null || cNamaAyah.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Ayah Wajib di Isi',
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
          } else if (cTtlAyah.text == null || cTtlAyah.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Tempat Wajib di Isi',
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
          } else if (cTglAyah.text == null || cTglAyah.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Tanggal Wajib di Isi',
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
          } else if (cNamaIbu.text == null || cNamaIbu.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Ibu Wajib di Isi',
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
          } else if (cTtlIbu.text == null || cTtlIbu.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Tempat Wajib di Isi',
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
          } else if (cTglIbu.text == null || cTglIbu.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Tanggal Wajib di Isi',
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
          } else if (cAnakke.text == null || cAnakke.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Anak ke Wajib di Isi',
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
            inputPasienBelumMenikah();
          }
        },
        child: Text(
          'DAFTAR',
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

  // Widget _daftar() {
  //   MediaQueryData mediaQueryData = MediaQuery.of(context);
  //   return Container(
  //     width: mediaQueryData.size.width,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Text("Kesulitan mengisi?"),
  //         SizedBox(
  //           width: mediaQueryData.size.width * 0.01,
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             //inputPasienMenikah();
  //             //Navigator.pushNamed(context, '/HalPilihAKun');
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
