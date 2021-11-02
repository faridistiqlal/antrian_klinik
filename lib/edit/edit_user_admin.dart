import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:antrian_dokter/data.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class EditUserAdmin extends StatefulWidget {
  final String eNama,
      eAlamat,
      eKelaminSession,
      eHp,
      eEmail,
      eUsername,
      //ePassword,
      eStatus,
      eId;

  EditUserAdmin({
    this.eNama,
    this.eAlamat,
    this.eKelaminSession,
    this.eHp,
    this.eEmail,
    this.eUsername,
    //this.ePassword,
    this.eStatus,
    this.eId,
  });
  @override
  _EditUserAdminState createState() => _EditUserAdminState();
}

class _EditUserAdminState extends State<EditUserAdmin> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: unused_field
  bool _obscureText = true;
  // ignore: unused_field
  bool _loading = false;
  // ignore: unused_field
  bool _sudahlogin = false;

  TextEditingController eNama = new TextEditingController();
  TextEditingController eKelaminSession = new TextEditingController();
  TextEditingController eAlamat = new TextEditingController();
  String eKelamin;
  TextEditingController eHp = new TextEditingController();
  TextEditingController eEmail = new TextEditingController();
  TextEditingController eUsername = new TextEditingController();
  TextEditingController ePassword = new TextEditingController();
  TextEditingController eId = new TextEditingController();
  String eStatus;
  String password = '';

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
    eAlamat = new TextEditingController(text: "${widget.eAlamat}");
    eHp = new TextEditingController(text: "${widget.eHp}");
    eEmail = new TextEditingController(text: "${widget.eEmail}");
    eUsername = new TextEditingController(text: "${widget.eUsername}");
    //ePassword = new TextEditingController(text: "${widget.ePassword}");
    eId = new TextEditingController(text: "${widget.eId}");
    eKelaminSession =
        new TextEditingController(text: "${widget.eKelaminSession}");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print(eStatus);
  }

  void _editUser() async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    //SharedPreferences pref = await SharedPreferences.getInstance();
    setState(
      () {
        _loading = true;
      },
    );
    Future.delayed(
      Duration(seconds: 2),
      () async {
        if (ePassword.text == null || ePassword.text == '') {
          password = '';
        } else {
          password = ePassword.text;
        }
        String theUrl = getMyUrl.url + 'User/Edit';
        if (eKelamin == null || eKelamin == '') {
          var res = await http.post(
            Uri.encodeFull(theUrl),
            headers: {"Accept": "application/json"},
            body: {
              "id": eId.text,
              "nama": eNama.text,
              "alamat": eAlamat.text,
              "kelamin": "${widget.eKelaminSession}",
              "hp": eHp.text,
              "email": eEmail.text,
              "username": eUsername.text,
              "password": password,
              "status": '0',
              // "status": pref.getString('IdUser').toString(),
            },
          );
          var editUser = json.decode(res.body);
          print(editUser);
          if (editUser['Status'] == 'EditUserBerhasil') {
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
                    'User berhasil diedit',
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
          } else if (editUser['Status'] == 'EditUserGagal') {
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
                    Icons.error,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.width * 0.01,
                  ),
                  Text(
                    'User gagal diedit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('Gagal');
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
              duration: Duration(seconds: 2),
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
                    'User Gagal diedit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('Gagal');
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
              "id": eId.text,
              "nama": eNama.text,
              "alamat": eAlamat.text,
              "kelamin": eKelamin,
              "hp": eHp.text,
              "email": eEmail.text,
              "username": eUsername.text,
              "password": password,
              "status": '0',
              // "status": pref.getString('IdUser').toString(),
            },
          );
          var editUser = json.decode(res.body);
          print(editUser);
          if (editUser['Status'] == 'EditUserBerhasil') {
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
                    'User berhasil diedit',
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
          } else if (editUser['Status'] == 'EditUserGagal') {
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
                    Icons.error,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.width * 0.01,
                  ),
                  Text(
                    'User gagal diedit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('Gagal');
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
              duration: Duration(seconds: 2),
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
                    'User Gagal diedit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('Gagal');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
          }
        }

        // if (inputUser['Status'] == 'EditUserBerhasil') {
        // if (this.mounted) {
        // setState(
        //   () {
        //     _loading = false;
        //   },
        // );

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DashbordAdmin(),
        //   ),
        // );
        // }
        // print(inputUser);
        // } else {
        // print(inputUser);
        // if (this.mounted) {
        // setState(
        //   () {
        //     _loading = false;
        //   },
        // );
        // }
        // Alert(
        //   context: context,
        //   title: "Input Gagal",
        //   desc: "Coba Ulangi lagi",
        //   type: AlertType.error,
        //   style: alertStyle,
        //   buttons: [
        //     DialogButton(
        //       child: Text(
        //         "Ulangi",
        //         style: TextStyle(color: Colors.white, fontSize: 20),
        //       ),
        //       onPressed: () => Navigator.pop(context),
        //       color: Colors.red,
        //       radius: BorderRadius.circular(15.0),
        //     ),
        //   ],
        // ).show();
        // print("Gagal");
        // }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      // resizeToAvoidBottomInset: false,
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
                  _inputuser(),
                ],
              ),
            ),
            // _logo(),
            Container(
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: mediaQueryData.size.height * 0.03,
                  right: mediaQueryData.size.height * 0.03,
                  // bottom: mediaQueryData.size.height * 0.02,
                  // top: mediaQueryData.size.height * 0.001,
                ),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
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
                    _inputAlamat(),

                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _inputKelamin(),
                    // new Padding(
                    //   padding: new EdgeInsets.only(
                    //       top: mediaQueryData.size.height * 0.03),
                    // ),
                    // _inputKelamin(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _inputHp(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),

                    _inputEmail(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _inputUsername(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _inputPassword(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
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
          ],
        ),
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
            'Edit Admin',
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
          hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  // Widget _logo() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //           image: AssetImage(
  //             "assets/images/pilihakun.png",
  //           ),
  //           fit: BoxFit.fitWidth,
  //           alignment: Alignment.topCenter),
  //     ),
  //   );
  // }

  Widget _inputAlamat() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: eAlamat,
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
          hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(
            Icons.location_on,
            color: Colors.grey,
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
        items: <String>[
          'L',
          'P',
        ].map(
          (String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          },
        ).toList(),
        onChanged: (newVal) {
          setState(
            () {
              eKelamin = newVal;
            },
          );
        },
        value: eKelamin,
      ),
    );
  }

  Widget _inputHp() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: eHp,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Nomer Hp',
          hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(
            Icons.phone_android,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputEmail() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: eEmail,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Email',
          hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(
            Icons.email,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputUsername() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: eUsername,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Username',
          hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(
            Icons.perm_identity,
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
        controller: ePassword,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Passsword',
          hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(
            Icons.lock,
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
          } else if (eAlamat.text == null || eAlamat.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Alamat belum di Isi',
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
          //  else if (eKelamin == null || eKelamin == '') {
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
          else if (eHp.text == null || eHp.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Hp belum di Isi',
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
          // else if (eEmail.text == null || eEmail.text == '') {
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
          // }
          else if (eUsername.text == null || eUsername.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Username belum di Isi',
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
          // else if (ePassword.text == null || ePassword.text == '') {
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
          // }
          // else if (eStatus == null || eStatus == '') {
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
          // }
          else {
            _editUser();
          }
        },
        child: Text(
          'SIMPAN',
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
