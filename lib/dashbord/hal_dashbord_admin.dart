import 'package:antrian_dokter/halaman/hal_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashbordAdmin extends StatefulWidget {
  @override
  _DashbordAdminState createState() => _DashbordAdminState();
}

class _DashbordAdminState extends State<DashbordAdmin> {
  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String nama = "";
  String status = "";
  void initState() {
    _cekUser();
    _cekLogin();
    super.initState();
  }

  // ignore: unused_field
  bool _isLoggedIn = false;
  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new DaftarAdmin()));
    }
  }

  // ignore: unused_element
  Future _cekLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == null) {
      _isLoggedIn = false;
      Navigator.pushReplacementNamed(context, '/DaftarAdmin');
    } else {
      _isLoggedIn = true;
    }
  }

  Future _cekUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("StatusUser") != null) {
      setState(
        () {
          nama = pref.getString("Nama");
          status = pref.getString("StatusUser");
        },
      );
    }
    print(status);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF44AEA5),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: _logo(),
        centerTitle: true,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.person),
        //     color: Colors.white,
        //     onPressed: () async {
        //       Navigator.pushNamed(context, '/HalProfilAdmin');
        //     },
        //   )
        // ],
      ),
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
                _user(),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[],
                ),
              ),
              _textTop(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _adddokter(),
                  _addlayanan(),
                  _adduser(),
                  _addjadwal(),
                ],
              ),
              _textbottom(),
              _menuBottom(),
            ],
          )
        ],
      ),
    );
  }

  Widget _logo() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/logoputih.png",
          width: mediaQueryData.size.width * 0.05,
          height: mediaQueryData.size.height * 0.05,
        ),
        Text(
          "  Klinik",
          style: new TextStyle(
              fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _user() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.all(mediaQueryData.size.height * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hai, " + nama,
            style: new TextStyle(
              fontSize: 25.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
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

  Widget _adddokter() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.15,
        // left: mediaQueryData.size.height * 0.01,
        // right: mediaQueryData.size.height * 0.01,
        bottom: mediaQueryData.size.height * 0.02,
      ),
      child: Container(
        height: mediaQueryData.size.height * 0.12,
        width: mediaQueryData.size.width * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0.0, 5.0),
                blurRadius: 10.0),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: <Widget>[
                    IconButton(
                      padding:
                          EdgeInsets.all(mediaQueryData.size.height * 0.017),
                      icon: Icon(Icons.local_hospital),
                      color: Color(0xFF44AEA5),
                      iconSize: 45.0,
                      onPressed: () {
                        Navigator.pushNamed(context, '/InputDokter');
                      },
                    ),
                    Text(
                      'Dokter',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _addlayanan() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.15,
        // left: mediaQueryData.size.height * 0.01,
        // right: mediaQueryData.size.height * 0.01,
        bottom: mediaQueryData.size.height * 0.02,
      ),
      child: Container(
        height: mediaQueryData.size.height * 0.12,
        width: mediaQueryData.size.width * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0.0, 5.0),
                blurRadius: 10.0),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: <Widget>[
                    IconButton(
                      padding:
                          EdgeInsets.all(mediaQueryData.size.height * 0.017),
                      icon: Icon(Icons.airline_seat_flat_angled),
                      color: Color(0xFF44AEA5),
                      iconSize: 45.0,
                      onPressed: () {
                        Navigator.pushNamed(context, '/InputLayanan');
                      },
                    ),
                    Text(
                      'Layanan',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _adduser() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.15,
        // left: mediaQueryData.size.height * 0.01,
        // right: mediaQueryData.size.height * 0.01,
        bottom: mediaQueryData.size.height * 0.02,
      ),
      child: Container(
        height: mediaQueryData.size.height * 0.12,
        width: mediaQueryData.size.width * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0.0, 5.0),
                blurRadius: 10.0),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: <Widget>[
                    IconButton(
                      padding:
                          EdgeInsets.all(mediaQueryData.size.height * 0.017),
                      icon: Icon(Icons.person_add),
                      color: Color(0xFF44AEA5),
                      iconSize: 45.0,
                      onPressed: () {
                        Navigator.pushNamed(context, '/HalPilihUserAdmin');

                        // Navigator.pushNamed(context, '/InputUser');
                      },
                    ),
                    Text(
                      'User',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _addjadwal() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.15,
        // left: mediaQueryData.size.height * 0.01,
        // right: mediaQueryData.size.height * 0.01,
        bottom: mediaQueryData.size.height * 0.02,
      ),
      child: Container(
        height: mediaQueryData.size.height * 0.12,
        width: mediaQueryData.size.width * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0.0, 5.0),
                blurRadius: 10.0),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: <Widget>[
                    IconButton(
                      padding:
                          EdgeInsets.all(mediaQueryData.size.height * 0.017),
                      icon: Icon(Icons.schedule),
                      color: Color(0xFF44AEA5),
                      iconSize: 45.0,
                      onPressed: () {
                        Navigator.pushNamed(context, '/InputJadwal');
                      },
                    ),
                    Text(
                      'Jadwal',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget _menuTop() {
  //   MediaQueryData mediaQueryData = MediaQuery.of(context);
  //   return Padding(
  //     padding: EdgeInsets.only(
  //       top: mediaQueryData.size.height * 0.12,
  //       left: mediaQueryData.size.height * 0.01,
  //       right: mediaQueryData.size.height * 0.01,
  //       bottom: mediaQueryData.size.height * 0.02,
  //     ),
  //     child: Container(
  //       padding: EdgeInsets.all(mediaQueryData.size.height * 0.02),
  //       height: mediaQueryData.size.height * 0.18,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.all(Radius.circular(15.0)),
  //         boxShadow: [
  //           BoxShadow(
  //               color: Colors.black.withOpacity(0.1),
  //               offset: Offset(0.0, 5.0),
  //               blurRadius: 10.0),
  //         ],
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           // _textTop(),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               Card(
  //                 child: Column(
  //                   children: <Widget>[
  //                     Material(
  //                       borderRadius: BorderRadius.circular(15.0),
  //                       color: Colors.red.withOpacity(0.2),
  //                       child: IconButton(
  //                         padding: EdgeInsets.all(
  //                             mediaQueryData.size.height * 0.017),
  //                         icon: Icon(Icons.local_hospital),
  //                         color: Colors.red,
  //                         iconSize: 30.0,
  //                         onPressed: () {
  //                           Navigator.pushNamed(context, '/InputDokter');
  //                         },
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.only(
  //                         top: mediaQueryData.size.height * 0.01,
  //                       ),
  //                       child: Text(
  //                         'Add Dokter',
  //                         style: TextStyle(
  //                           color: Colors.black54,
  //                           fontSize: 12.0,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Column(
  //                 children: <Widget>[
  //                   Material(
  //                     borderRadius: BorderRadius.circular(15.0),
  //                     color: Colors.blue.withOpacity(0.2),
  //                     child: IconButton(
  //                       padding:
  //                           EdgeInsets.all(mediaQueryData.size.height * 0.017),
  //                       icon: Icon(Icons.airline_seat_flat_angled),
  //                       color: Colors.blue,
  //                       iconSize: 30.0,
  //                       onPressed: () {
  //                         Navigator.pushNamed(context, '/InputLayanan');
  //                       },
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(
  //                       top: mediaQueryData.size.height * 0.01,
  //                     ),
  //                     child: Text(
  //                       'Layanan',
  //                       style: TextStyle(
  //                         color: Colors.black54,
  //                         fontSize: 12.0,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Column(
  //                 children: <Widget>[
  //                   Material(
  //                     borderRadius: BorderRadius.circular(15.0),
  //                     color: Colors.orange.withOpacity(0.2),
  //                     child: IconButton(
  //                       padding:
  //                           EdgeInsets.all(mediaQueryData.size.height * 0.017),
  //                       icon: Icon(Icons.person_add),
  //                       color: Colors.orange,
  //                       iconSize: 30.0,
  //                       onPressed: () {
  //                         //Navigator.pushNamed(context, '/HalamanBeritaadmin');
  //                       },
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(
  //                       top: mediaQueryData.size.height * 0.01,
  //                     ),
  //                     child: Text(
  //                       'User',
  //                       style: TextStyle(
  //                         color: Colors.black54,
  //                         fontSize: 12.0,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Column(
  //                 children: <Widget>[
  //                   Material(
  //                     borderRadius: BorderRadius.circular(15.0),
  //                     color: Colors.green.withOpacity(0.2),
  //                     child: IconButton(
  //                       padding:
  //                           EdgeInsets.all(mediaQueryData.size.height * 0.017),
  //                       icon: Icon(Icons.schedule),
  //                       color: Colors.green,
  //                       iconSize: 30.0,
  //                       onPressed: () async {
  //                         // SharedPreferences pref =
  //                         //     await SharedPreferences.getInstance();
  //                         // pref.clear();
  //                         // _cekLogout();
  //                       },
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(
  //                       top: mediaQueryData.size.height * 0.01,
  //                     ),
  //                     child: Text(
  //                       'Jadwal',
  //                       style: TextStyle(
  //                         color: Colors.black54,
  //                         fontSize: 12.0,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // ignore: unused_element
  Widget _textbottom() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.3,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Text(
        "Detail Data",
        style: new TextStyle(
          fontSize: 18.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textTop() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.11,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Text(
        "Input",
        style: new TextStyle(
          fontSize: 20.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _menuBottom() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.35,
        left: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Container(
        padding: EdgeInsets.all(mediaQueryData.size.height * 0.01),
        height: mediaQueryData.size.height,
        width: mediaQueryData.size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0.0, 5.0),
                blurRadius: 10.0),
          ],
        ),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/ListDokter');
                },
                child: ListTile(
                  leading: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xFF44AEA5).withOpacity(0.2),
                    child: IconButton(
                      padding: EdgeInsets.all(15.0),
                      icon: Icon(
                        Icons.local_hospital,
                      ),
                      color: Color(0xFF44AEA5),
                      iconSize: 25.0,
                      onPressed: () {
                        // Navigator.pushNamed(context, '/ListDokter');
                      },
                    ),
                  ),
                  subtitle: new Text(
                    "Lihat detail Dokter",
                    style: new TextStyle(fontSize: 12.0, color: Colors.black54),
                  ),
                  title: new Text(
                    "Dokter",
                    style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 14.0, color: Colors.black),
                ),
              ),
            ),
            Divider(),
            Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/ListLayanan');
                },
                child: ListTile(
                  leading: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xFF44AEA5).withOpacity(0.2),
                    child: IconButton(
                      padding: EdgeInsets.all(15.0),
                      icon: Icon(Icons.airline_seat_flat_angled),
                      color: Color(0xFF44AEA5),
                      iconSize: 25.0,
                      onPressed: () {
                        // Navigator.pushNamed(context, '/ListLayanan');
                      },
                    ),
                  ),
                  subtitle: new Text(
                    "Lihat detail Layanan",
                    style: new TextStyle(fontSize: 12.0, color: Colors.black54),
                  ),
                  title: new Text(
                    "Layanan",
                    style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 14.0, color: Colors.black),
                ),
              ),
            ),
            Divider(),
            Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/ListUser');
                },
                child: ListTile(
                  leading: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xFF44AEA5).withOpacity(0.2),
                    child: IconButton(
                      padding: EdgeInsets.all(15.0),
                      icon: Icon(Icons.person_add),
                      color: Color(0xFF44AEA5),
                      iconSize: 25.0,
                      onPressed: () {
                        //Navigator.pushNamed(context, '/ListUser');
                      },
                    ),
                  ),
                  subtitle: new Text(
                    "Lihat detail User",
                    style: new TextStyle(fontSize: 12.0, color: Colors.black54),
                  ),
                  title: new Text(
                    "User",
                    style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 14.0, color: Colors.black),
                ),
              ),
            ),
            Divider(),
            Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/ListJadwal');
                },
                child: ListTile(
                  leading: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xFF44AEA5).withOpacity(0.2),
                    child: IconButton(
                      padding: EdgeInsets.all(15.0),
                      icon: Icon(Icons.schedule),
                      color: Color(0xFF44AEA5),
                      iconSize: 25.0,
                      onPressed: () {
                        //Navigator.pushNamed(context, '/ListJadwal');
                      },
                    ),
                  ),
                  subtitle: new Text(
                    "Lihat detail Jadwal",
                    style: new TextStyle(fontSize: 12.0, color: Colors.black54),
                  ),
                  title: new Text(
                    "Jadwal",
                    style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 14.0, color: Colors.black),
                ),
              ),
            ),
            Divider(),
            Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/Listkeluarga');
                },
                child: ListTile(
                  leading: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xFF44AEA5).withOpacity(0.2),
                    child: IconButton(
                      padding: EdgeInsets.all(15.0),
                      icon: Icon(Icons.people),
                      color: Color(0xFF44AEA5),
                      iconSize: 25.0,
                      onPressed: () {
                        //Navigator.pushNamed(context, '/ListJadwal');
                      },
                    ),
                  ),
                  subtitle: new Text(
                    "Lihat detail Keluarga",
                    style: new TextStyle(fontSize: 12.0, color: Colors.black54),
                  ),
                  title: new Text(
                    "Keluarga",
                    style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 14.0, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
