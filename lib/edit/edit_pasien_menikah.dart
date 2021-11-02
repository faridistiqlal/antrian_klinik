import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:antrian_dokter/data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditpasienMenikah extends StatefulWidget {
  @override
  _EditpasienMenikahState createState() => _EditpasienMenikahState();
}

class _EditpasienMenikahState extends State<EditpasienMenikah> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var data;
  bool _loading = false;
  String eNorm = '';
  String eNoKK = '';
  String eNama = '';
  String eTTL = '';
  String ePasangan = '';
  String eTTLPasangan = '';
  String eKelamin = '';
  String eAlamat = '';
  String eHp = '';
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

  TextEditingController cNorm = new TextEditingController();
  TextEditingController cNoKK = new TextEditingController();
  TextEditingController cNama = new TextEditingController();
  TextEditingController cTTL = new TextEditingController();
  TextEditingController cPasangan = new TextEditingController();
  TextEditingController cTTLPasangan = new TextEditingController();
  String cKelamin;
  TextEditingController cAlamat = new TextEditingController();
  TextEditingController cKelaminC = new TextEditingController();
  TextEditingController cHp = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String theUrl = getMyUrl.url + 'Pasien/GetDataMenikah';
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
        eNorm = data['NoRm'];
        eNoKK = data['NoKK'];
        eNama = data['Nama'];
        eTTL = data['TTL'];
        ePasangan = data['Pasangan'];
        eTTLPasangan = data['TTLPasangan'];
        eKelamin = data['Kelamin'];
        eAlamat = data['Alamat'];
        eHp = data['Hp'];

        cNorm = new TextEditingController(text: eNorm);
        cNoKK = new TextEditingController(text: eNoKK);
        cNama = new TextEditingController(text: eNama);
        cTTL = new TextEditingController(text: eTTL);
        cPasangan = new TextEditingController(text: ePasangan);
        cTTLPasangan = new TextEditingController(text: eTTLPasangan);
        cAlamat = new TextEditingController(text: eAlamat);
        cHp = new TextEditingController(text: eHp);
        cKelaminC = new TextEditingController(text: eKelamin);
      },
    );
    print(data);
  }

  void editmenikah() async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    setState(
      () {
        _loading = true;
      },
    );
    Future.delayed(
      Duration(seconds: 2),
      () async {
        String theUrl = getMyUrl.url + 'Pasien/EditDataMenikah';
        if (cKelamin == null || cKelamin == '') {
          var res = await http.post(
            Uri.encodeFull(theUrl),
            headers: {"Accept": "application/json"},
            body: {
              "kk": cNoKK.text,
              "nama": cNama.text,
              "ttl": cTTL.text,
              "namapasangan": cPasangan.text,
              "ttlpasangan": cTTLPasangan.text,
              "kelamin": cKelaminC.text,
              "alamat": cAlamat.text,
              "hp": cHp.text,
              "norm": cNorm.text,
            },
          );
          var responsBody = json.decode(res.body);
          print(responsBody);
          if (responsBody['Status'] == 'Sukses') {
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
                    'Edit data sukses',
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
                    '/HalCek', ModalRoute.withName('/HalCek'));
              },
            );
          } else if (responsBody['Status'] == 'Gagal') {
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
                    'Gagal mengedit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('Berhasil');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
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
                    'Gagal mengedit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('Berhasil');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
          }
        } else {
          var res = await http.post(
            Uri.encodeFull(theUrl),
            headers: {"Accept": "application/json"},
            body: {
              "kk": cNoKK.text,
              "nama": cNama.text,
              "ttl": cTTL.text,
              "namapasangan": cPasangan.text,
              "ttlpasangan": cTTLPasangan.text,
              "kelamin": cKelamin,
              "alamat": cAlamat.text,
              "hp": cHp.text,
              "norm": cNorm.text,
            },
          );
          var responsBody = json.decode(res.body);
          print(responsBody);
          if (responsBody['Status'] == 'Sukses') {
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
                    'Edit data sukses',
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
                    '/HalCek', ModalRoute.withName('/HalCek'));
              },
            );
          } else if (responsBody['Status'] == 'Gagal') {
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
                    'Gagal mengedit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('Berhasil');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
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
                    'Gagal mengedit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('Berhasil');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
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
            _logo(),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: mediaQueryData.size.height * 0.02,
                  right: mediaQueryData.size.height * 0.02,
                ),
                child: Container(
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _text(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.02),
                      ),
                      _inputkk(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.02),
                      ),
                      _inputnama(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.02),
                      ),
                      _inputttl(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.02),
                      ),
                      _inputnamapasangan(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.02),
                      ),
                      _inputttlpasangan(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.02),
                      ),
                      _inputkelamin(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.02),
                      ),

                      _inputalamat(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.02),
                      ),

                      _inputhp(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.02),
                      ),

                      _inputnorm(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.05),
                      ),
                      _loginButton(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.05),
                      ),
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
    return Container(
      child: Text(
        "Edit Data",
        style: new TextStyle(
          fontSize: 25.0,
          color: Colors.grey[800],
          fontWeight: FontWeight.bold,
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

  Widget _inputkk() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: cNoKK,
        // enabled: false,
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
            Icons.format_list_numbered,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputnama() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.name,
        controller: cNama,
        // enabled: false,
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

  Widget _inputttl() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.name,
        controller: cTTL,
        // enabled: false,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'TTL',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.calendar_today,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputnamapasangan() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.name,
        controller: cPasangan,
        // enabled: false,
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
            Icons.people,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputttlpasangan() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.name,
        controller: cTTLPasangan,
        // enabled: false,
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
            Icons.calendar_today,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputkelamin() {
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
              cKelamin = newVal;
            },
          );
        },
        value: cKelamin,
      ),
    );
  }

  Widget _inputalamat() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.name,
        controller: cAlamat,
        // enabled: false,
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

  Widget _inputhp() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: cHp,
        // enabled: false,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'No Hp',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.phone,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputnorm() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: cNorm,
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
          hintText: 'No RM',
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

  Widget _loginButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: mediaQueryData.size.height * 0.07,
      child: RaisedButton(
        onPressed: () async {
          editmenikah();
          // _focusNode.unfocus();
          // _addJanji();
          // if (cNama.text == null || cNama.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Nama Wajib di Isi',
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
          //       'Alamat belum di Isi',
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
          // } else if (cKelamin == null || cKelamin == '') {
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
          // } else if (cHp.text == null || cHp.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Hp belum di Isi',
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
          // } else if (cEmail.text == null || cEmail.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Hp belum di Isi',
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
          // } else if (cUsername.text == null || cUsername.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Username belum di Isi',
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
          // } else if (cPassword.text == null || cPassword.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'password belum di Isi',
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
          // } else if (cStatus == null || cStatus == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'status belum di Isi',
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
          //   _addjadwal();
          // }
        },
        child: Text(
          'UBAH DATA',
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
