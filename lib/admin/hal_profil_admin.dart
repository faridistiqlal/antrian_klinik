import 'package:antrian_dokter/edit/edit_user_admin.dart';
import 'package:antrian_dokter/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:antrian_dokter/data.dart';

class HalProfilAdmin extends StatefulWidget {
  @override
  _HalProfilAdminState createState() => _HalProfilAdminState();
}

class _HalProfilAdminState extends State<HalProfilAdmin> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String nama = "";
  String email = "";
  String hp = "";
  String kelamin = "";
  String alamat = "";

  String user = "";
  String iduser = "";
  String status = "";

  var data;
  // ignore: unused_field
  bool _isLoggedIn = false;
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
  // void _cekUser() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   setState(
  //     () {
  //       nama = pref.getString("Nama");
  //       email = pref.getString("Email");
  //       hp = pref.getString("Hp");
  //       kelamin = pref.getString("Kelamin");
  //       alamat = pref.getString("Alamat");
  //       user = pref.getString("Username");
  //       id = pref.getString("IdUser");
  //     },
  //   );
  // }

  void getDataAdmin() async {
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
    this.setState(
      () {
        nama = data['Nama'];
        email = data['Email'];
        hp = data['Hp'];
        kelamin = data['Kelamin'];
        alamat = data['Alamat'];
        iduser = data['IdUser'];
        user = data['UserName'];
        status = pref.getString("StatusUser");
      },
    );
    print(data);
  }

  Future _cekLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == null) {
      _isLoggedIn = false;
      // Navigator.pushReplacementNamed(context, '/DaftarAdmin');
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/DaftarAdmin', ModalRoute.withName('/DaftarAdmin'));

      print("Logout");
    } else {
      _isLoggedIn = true;
    }
  }

  void initState() {
    // _cekUser();
    getDataAdmin();
    print(nama);
    super.initState();
  }

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
                _inputuser(),
              ],
            ),
          ),
          // _logo(),
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
                        _logoutAdmin(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _inputuser() {
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
            "Profil Admin",
            style: new TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget namaAdmin() {
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: Icon(
          Icons.person,
          size: 30.0,
          color: Color(0xFF44AEA5),
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
            color: Color(0xFF44AEA5),
          ),
        ),
        dense: true,
      ),
    );
  }

  Widget emailAdmin() {
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: Icon(
          Icons.email,
          size: 30.0,
          color: Color(0xFF44AEA5),
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
            color: Color(0xFF44AEA5),
          ),
        ),
        dense: true,
      ),
    );
  }

  Widget hpAdmin() {
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: Icon(
          Icons.phone_android,
          size: 30.0,
          color: Color(0xFF44AEA5),
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
            color: Color(0xFF44AEA5),
          ),
        ),
        dense: true,
      ),
    );
  }

  Widget kelaminAdmin() {
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: Icon(
          Icons.accessibility,
          size: 30.0,
          color: Color(0xFF44AEA5),
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
            color: Color(0xFF44AEA5),
          ),
        ),
        dense: true,
      ),
    );
  }

  Widget alamatAdmin() {
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: Icon(
          Icons.location_on,
          size: 30.0,
          color: Color(0xFF44AEA5),
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
            color: Color(0xFF44AEA5),
          ),
        ),
        dense: true,
      ),
    );
  }

  Widget userAdmin() {
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: Icon(
          Icons.accessibility,
          size: 30.0,
          color: Color(0xFF44AEA5),
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
            color: Color(0xFF44AEA5),
          ),
        ),
        dense: true,
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
          // Navigator.pushNamed(context, '/EditUserAdmin');
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new EditUserAdmin(
                eNama: nama,
                eAlamat: alamat,
                eKelaminSession: kelamin,
                eHp: hp,
                eEmail: email,
                eUsername: user,
                //ePassword: dataJSON[i]["Password"],
                eStatus: status,
                eId: iduser,
              ),
            ),
          );
          // nama = pref.getString("Nama");
          // email = pref.getString("Email");
          // hp = pref.getString("Hp");
          // kelamin = pref.getString("Kelamin");
          // alamat = pref.getString("Alamat");
          // user = pref.getString("Username");
        },
        child: Text(
          'Edit',
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
            title: "Log out",
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
            fontSize: 18,
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
