import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:antrian_dokter/data.dart';
import 'dart:async';

class DaftarAdmin extends StatefulWidget {
  //  final String cusername, cpassword;

  // DaftarAdmin({this.cusername, this.cpassword,});
  @override
  _DaftarAdminState createState() => _DaftarAdminState();
}

class _DaftarAdminState extends State<DaftarAdmin> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _obscureText = true;
  bool _loading = false;
  // ignore: unused_field
  bool _sudahlogin = false;
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _cekLogin();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_sudahlogin") == true) {
      _sudahlogin = true;
      if (pref.getString('StatusUser') == '0') {
        Navigator.pushReplacementNamed(context, '/HalTabAdmin');
      } else {
        Navigator.pushReplacementNamed(context, '/HalCek');
      }
    } else {
      _sudahlogin = false;
    }
    // print(pref.getString('StatusUser'));
  }

  void _toggle() {
    setState(
      () {
        _obscureText = !_obscureText;
      },
    );
  }

  void _login() async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    setState(
      () {
        _loading = true;
      },
    );
    Future.delayed(
      Duration(seconds: 2),
      () async {
        String theUrl = getMyUrl.url + 'Login/verify';
        var res = await http.post(
          Uri.encodeFull(theUrl),
          headers: {"Accept": "application/json"},
          body: {
            "username": username.text,
            "password": password.text,
          },
        );
        var loginuser = json.decode(res.body);
        if (loginuser['Status'] == 'UserNameNotFound') {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool("_sudahlogin", false);
          setState(
            () {
              _loading = false;
            },
          );

          print(loginuser);
          print("username salah");
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
                  ' Username salah',
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
        } else if (loginuser['Status'] == 'WrongPassword') {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool("_sudahlogin", false);
          setState(
            () {
              _loading = false;
            },
          );
          print(loginuser);
          print("password salah");
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
                  ' Password salah',
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
          if (loginuser['StatusUser'] == '9') {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setBool("_sudahlogin", true);
            pref.setString('IdUser', loginuser['IdUser']);
            pref.setString('Nama', loginuser['Nama']);
            pref.setString('Alamat', loginuser['Alamat']);
            pref.setString('Kelamin', loginuser['Kelamin']);
            pref.setString('Hp', loginuser['Hp']);
            pref.setString('Email', loginuser['Email']);
            pref.setString('Username', loginuser['Username']);
            pref.setString('Status', loginuser['StatusUser']);
            pref.setString('StatusPasien', loginuser['StatusPasien']);
            setState(
              () {
                _loading = false;
              },
            );
            print(loginuser);
            print("Berhasil login");
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/HalCek',
              ModalRoute.withName('/HalCek'),
            );
          } else if (loginuser['StatusUser'] == '0') {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setBool("_sudahlogin", true);
            pref.setString('IdUser', loginuser['IdUser']);
            pref.setString('Nama', loginuser['Nama']);
            pref.setString('Alamat', loginuser['Alamat']);
            pref.setString('Kelamin', loginuser['Kelamin']);
            pref.setString('Hp', loginuser['Hp']);
            pref.setString('Email', loginuser['Email']);
            pref.setString('Username', loginuser['Username']);
            pref.setString('StatusUser', loginuser['StatusUser']);
            setState(
              () {
                _loading = false;
              },
            );
            print(loginuser);
            print("Berhasil login");
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/HalTabAdmin',
              ModalRoute.withName('/HalTabAdmin'),
            );
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
            _logo(),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.26),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(mediaQueryData.size.height * 0.04),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _text(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.03),
                      ),
                      _inputNIK(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.03),
                      ),
                      _inputPassword(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.05),
                      ),
                      _loginButton(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.08),
                      ),
                      _daftar(),
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

  Widget _text() {
    return GestureDetector(
      onTap: () {},
      child: Text(
        "Login",
        style: new TextStyle(
            fontSize: 28.0,
            color: Colors.grey[800],
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _logo() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              "assets/images/login2.png",
            ),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter),
      ),
    );
  }

  Widget _inputNIK() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: username,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'NIK',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.person_outline,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputPassword() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: password,
        obscureText: _obscureText,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye),
            color: Colors.grey,
            iconSize: 20.0,
            onPressed: _toggle,
          ),
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Passowrd',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
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
          _login();
        },
        child: Text(
          'LOGIN',
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
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Belum punya akun?"),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/HalPilihAKun');
            },
            child: Text(
              "  Daftar",
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
