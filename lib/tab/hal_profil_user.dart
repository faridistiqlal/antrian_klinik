//import 'package:antrian_dokter/edit/edit_user.dart';
import 'package:antrian_dokter/edit/edit_user_pasien.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:antrian_dokter/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var data;

  String nama = "";
  String email = "";
  String hp = "";
  String kelamin = "";
  String alamat = "";
  String user = "";
  String iduser = "";
  // ignore: unused_field
  bool _isLoggedIn = false;
  String statusPasien = '';

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

  void _editPasien() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String theUrl = getMyUrl.url + 'Pasien/GetKK';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
      body: {
        "NoRm": pref.getString("Username"),
      },
    );
    print(res);
    if (this.mounted) {
      setState(
        () {
          statusPasien = pref.getString("StatusPasien");
        },
      );
    }

    if (statusPasien == 'Ibu' || statusPasien == 'Ayah') {
      Navigator.pushNamed(context, '/EditpasienMenikah');
    } else {
      Navigator.pushNamed(context, '/EditpasienBlmMenikah');
    }
  }

  // Future _cekUser() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   if (pref.getString("Status") != null) {
  //     setState(
  //       () {
  //         nama = pref.getString("Nama");
  //         email = pref.getString("Email");
  //         hp = pref.getString("Hp");
  //         kelamin = pref.getString("Kelamin");
  //         alamat = pref.getString("Alamat");
  //         user = pref.getString("Username");
  //         iduser = pref.getString("IdUser");
  //       },
  //     );
  //   }
  // }

  void getDataPasien() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String theUrl = getMyUrl.url + 'User/GetData';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
      body: {
        "id": pref.getString("IdUser"),
      },
    );
    data = json.decode(res.body);
    if (this.mounted) {
      this.setState(
        () {
          nama = data['Nama'];
          email = data['Email'];
          hp = data['Hp'];
          kelamin = data['Kelamin'];
          alamat = data['Alamat'];
          iduser = data['IdUser'];
          user = data['UserName'];
          // statusPasien = pref.getString("StatusUser");
        },
      );
    }
    print(data);
  }

  Future _cekLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == null) {
      _isLoggedIn = false;

      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/DaftarAdmin', ModalRoute.withName('/DaftarAdmin'));

      print("Logout");
    } else {
      _isLoggedIn = true;
    }
  }

  void initState() {
    super.initState();
    getDataPasien();
    // _cekUser();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // SizeConfig().init(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          // Container(
          //   width: mediaQueryData.size.height,
          //   height: mediaQueryData.size.height * 0.4,
          //   decoration: BoxDecoration(
          //     color: Color(0xFF44AEA5),
          //   ),
          //   child: Column(
          //     children: <Widget>[
          //       _inputuser(),
          //     ],
          //   ),
          // ),
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
                    namaAdmin(),
                    Divider(),
                    emailAdmin(),
                    Divider(),
                    hpAdmin(),
                    Divider(),
                    kelaminAdmin(),
                    Divider(),
                    alamatAdmin(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _editAdmin(),
                        _editPasienDetail(),
                      ],
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _logoutAdmin(),
                      ],
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
      "Akun",
      style: new TextStyle(
        fontSize: 25.0,
        color: Colors.grey[800],
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget namaAdmin() {
    return InkWell(
      onTap: () {
        /*Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new FormBeritaDashbord(),
            ),
          );*/
      },
      child: ListTile(
        leading: Icon(
          Icons.person,
          size: 30.0,
          color: Colors.blueAccent[100],
        ),
        title: new Text(
          "Nama",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        subtitle: new Text(
          nama,
          style: new TextStyle(
            fontSize: 14.0,
            color: Colors.blueAccent[100],
          ),
        ),
        dense: true,
        /*trailing:
            Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),*/
      ),
    );
  }

  Widget emailAdmin() {
    return InkWell(
      onTap: () {
        /*Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new FormBeritaDashbord(),
            ),
          );*/
      },
      child: ListTile(
        leading: Icon(
          Icons.email,
          size: 30.0,
          color: Colors.blueAccent[100],
        ),
        title: new Text(
          "Email",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        subtitle: new Text(
          email,
          style: new TextStyle(
            fontSize: 14.0,
            color: Colors.blueAccent[100],
          ),
        ),
        dense: true,
        /*trailing:
            Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),*/
      ),
    );
  }

  Widget hpAdmin() {
    return InkWell(
      onTap: () {
        /*Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new FormBeritaDashbord(),
            ),
          );*/
      },
      child: ListTile(
        leading: Icon(
          Icons.phone_android,
          size: 30.0,
          color: Colors.blueAccent[100],
        ),
        title: new Text(
          "Hp",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        subtitle: new Text(
          hp,
          style: new TextStyle(
            fontSize: 14.0,
            color: Colors.blueAccent[100],
          ),
        ),
        dense: true,
        /*trailing:
            Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),*/
      ),
    );
  }

  Widget kelaminAdmin() {
    return InkWell(
      onTap: () {
        /*Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new FormBeritaDashbord(),
            ),
          );*/
      },
      child: ListTile(
        leading: Icon(
          Icons.accessibility,
          size: 30.0,
          color: Colors.blueAccent[100],
        ),
        title: new Text(
          "Kelamin",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        subtitle: new Text(
          kelamin,
          style: new TextStyle(
            fontSize: 14.0,
            color: Colors.blueAccent[100],
          ),
        ),
        dense: true,
        /*trailing:
            Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),*/
      ),
    );
  }

  Widget alamatAdmin() {
    return InkWell(
      onTap: () {
        /*Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new FormBeritaDashbord(),
            ),
          );*/
      },
      child: ListTile(
        leading: Icon(
          Icons.location_on,
          size: 30.0,
          color: Colors.blueAccent[100],
        ),
        title: new Text(
          "Alamat",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        subtitle: new Text(
          alamat,
          style: new TextStyle(
            fontSize: 14.0,
            color: Colors.blueAccent[100],
          ),
        ),
        dense: true,
        /*trailing:
            Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),*/
      ),
    );
  }

  Widget userAdmin() {
    return InkWell(
      onTap: () {
        /*Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new FormBeritaDashbord(),
            ),
          );*/
      },
      child: ListTile(
        leading: Icon(
          Icons.accessibility,
          size: 30.0,
          color: Colors.blueAccent[100],
        ),
        title: new Text(
          "User",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        subtitle: new Text(
          user,
          style: new TextStyle(
            fontSize: 14.0,
            color: Colors.blueAccent[100],
          ),
        ),
        dense: true,
        /*trailing:
            Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),*/
      ),
    );
  }

  Widget _editAdmin() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width * 0.4,
      height: mediaQueryData.size.height * 0.05,
      child: RaisedButton(
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          // _editPasien();
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new EditUserPasien(
                eNama: nama,
                eAlamat: alamat,
                eKelaminSession: kelamin,
                eHp: hp,
                eEmail: email,
                eUsername: user,
                //ePassword: dataJSON[i]["Password"],
                eStatus: pref.getString("StatusUser"),
                eId: iduser,
              ),
            ),
          );
        },
        child: Text(
          'Edit Akun',
          style: TextStyle(
            fontSize: 14,
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

  Widget _editPasienDetail() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width * 0.4,
      height: mediaQueryData.size.height * 0.05,
      child: RaisedButton(
        onPressed: () {
          _editPasien();
          // Navigator.pushNamed(context, '/Halkeluarga');
        },
        child: Text(
          'Edit Data',
          style: TextStyle(
            fontSize: 14,
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

  Widget _logoutAdmin() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width * 0.4,
      height: mediaQueryData.size.height * 0.05,
      child: RaisedButton(
        onPressed: () async {
          Alert(
            context: context,
            style: alertStyle,
            type: AlertType.warning,
            title: "Logout",
            desc: "Anda yakin ingin keluar akun?",
            buttons: [
              DialogButton(
                child: Text(
                  "Tidak",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () => Navigator.pop(context),
                color: Colors.green,
              ),
              DialogButton(
                child: Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.clear();
                  _cekLogout();
                  Navigator.pop(context);
                },
                color: Colors.red,
              )
            ],
          ).show();
          // SharedPreferences pref = await SharedPreferences.getInstance();
          // pref.clear();
          // _cekLogout();
        },
        child: Text(
          'Log Out',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Colors.red,
        elevation: 0,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
