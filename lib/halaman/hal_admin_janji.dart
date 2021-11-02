import 'package:antrian_dokter/halaman/hal_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; //api
import 'dart:convert';
import 'package:antrian_dokter/data.dart';
import 'package:shimmer/shimmer.dart';

class DashbordAdminJanji extends StatefulWidget {
  @override
  _DashbordAdminJanjiState createState() => _DashbordAdminJanjiState();
}

class _DashbordAdminJanjiState extends State<DashbordAdminJanji> {
  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String nama = "";
  List dataJSON;

  int jumlahhariini;
  int jumlahhariinibelum;
  int jumlahhariinisudah;
  int jumlahseminggu;
  int jumlahsebulan;
  int jumlahtotal;

  void initState() {
    super.initState();
    _cekLogin();
    _cekUser();

    jumlahAgenda();
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
        },
      );
    }
  }

  // ignore: missing_return
  // Future<String> ambildatajumlah() async {
  //   String theUrl = getMyUrl.url + 'appoiment/Jumlah';
  //   var res = await http.post(
  //     Uri.encodeFull(theUrl),
  //     headers: {"Accept": "application/json"},
  //     body: {
  //       "norm": '1',
  //     },
  //   );
  //   var jumlahdata = json.decode(res.body);
  //   print(jumlahdata);
  //   setState(() {
  //     jumlahhariini:
  //     jumlahdata["JumlahHariIni"];
  //   });
  // }

  Future jumlahAgenda() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    String theUrl = getMyUrl.url + 'appoiment/Jumlah';
    final response = await http.get(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
    );
    var jumlahagenda = json.decode(response.body);
    print(jumlahagenda);
    if (this.mounted) {
      setState(() {
        jumlahhariini = jumlahagenda['JumlahHariIni'];
        jumlahhariinibelum = jumlahagenda['JumlahHariIniBelum'];
        jumlahhariinisudah = jumlahagenda['JumlahHariIniSudah'];
        jumlahseminggu = jumlahagenda['JumlahSeminggu'];
        jumlahsebulan = jumlahagenda['JumlahSebulan'];
        jumlahtotal = jumlahagenda['JumlahSebulan'];
      });
    }
    return jumlahagenda;
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            color: Colors.white,
            onPressed: () async {
              Navigator.pushNamed(context, '/HalProfilAdmin');
            },
          )
        ],
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
                padding: EdgeInsets.all(2),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _cardorange(),
                    // _cardobiru(),
                    // cardBerita2(),
                    // cardBerita(),

                    _textTop(),
                    _janjiHariIni(),
                    _janjiAll(),
                  ],
                ),
              ),
              // _textTop(),
            ],
          )
        ],
      ),
    );
  }

  Widget cardBerita() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Stack(
      children: <Widget>[
        Padding(
          padding: new EdgeInsets.all(5.0),
          child: Container(
            width: mediaQueryData.size.width,
            height: mediaQueryData.size.height * 0.1,
            decoration: BoxDecoration(
              color: Color(0xFF44AEA5),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0.0, 3.0),
                    blurRadius: 15.0)
              ],
            ),
            child: Container(
              padding: EdgeInsets.only(
                top: mediaQueryData.size.height * 0.02,
                left: mediaQueryData.size.height * 0.02,
                right: mediaQueryData.size.height * 0.02,
                //bottom: mediaQueryData.size.height * 0.01,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Jumlah Data",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Pasien Klinik Selesai",
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          ),
                        ],
                      ),
                      Container(
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text("$jumlahseminggu",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0)),
                                SizedBox(height: 8.0),
                                Text('Minggu',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 13.0))
                              ],
                            ),
                            SizedBox(
                              width: mediaQueryData.size.width * 0.03,
                            ),
                            Column(
                              children: <Widget>[
                                Text("$jumlahsebulan",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0)),
                                SizedBox(height: 8.0),
                                Text('Bulan',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 13.0))
                              ],
                            ),
                            SizedBox(
                              width: mediaQueryData.size.width * 0.03,
                            ),
                            Column(
                              children: <Widget>[
                                Text("$jumlahtotal",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0)),
                                SizedBox(height: 8.0),
                                Text('Total',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 13.0))
                              ],
                            ),
                            SizedBox(
                              width: mediaQueryData.size.width * 0.03,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget cardBerita2() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: mediaQueryData.size.height * 0.01,
            left: mediaQueryData.size.height * 0.01,
            right: mediaQueryData.size.height * 0.01,
            //bottom: mediaQueryData.size.height * 0.01,
          ),
          child: Container(
            width: mediaQueryData.size.width,
            height: mediaQueryData.size.height * 0.15,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0.0, 3.0),
                    blurRadius: 15.0)
              ],
            ),
            child: Container(
              padding: EdgeInsets.only(
                top: mediaQueryData.size.height * 0.01,
                left: mediaQueryData.size.height * 0.01,
                right: mediaQueryData.size.height * 0.01,
                //bottom: mediaQueryData.size.height * 0.01,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          Text(
                            "Hari ini",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Pasien Aktif ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                          Text(
                            "$jumlahhariini",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                          height: mediaQueryData.size.height * 0.1,
                          child: VerticalDivider(color: Colors.white)),
                      Column(
                        children: [
                          Text(
                            "Belum",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$jumlahhariinibelum",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Selesai",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$jumlahhariinisudah",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: mediaQueryData.size.height * 0.17,
                left: mediaQueryData.size.height * 0.01,
                right: mediaQueryData.size.height * 0.011,
                //bottom: mediaQueryData.size.height * 0.01,
              ),
              child: Container(
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height * 0.1,
                decoration: BoxDecoration(
                  color: Color(0xFF44AEA5),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0.0, 3.0),
                        blurRadius: 15.0)
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    top: mediaQueryData.size.height * 0.02,
                    left: mediaQueryData.size.height * 0.02,
                    right: mediaQueryData.size.height * 0.02,
                    //bottom: mediaQueryData.size.height * 0.01,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Jumlah Data",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Pasien Klinik Selesai",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                            ],
                          ),
                          Container(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text("$jumlahseminggu",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0)),
                                    SizedBox(height: 8.0),
                                    Text('Minggu',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13.0))
                                  ],
                                ),
                                SizedBox(
                                  width: mediaQueryData.size.width * 0.03,
                                ),
                                Column(
                                  children: <Widget>[
                                    Text("$jumlahsebulan",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0)),
                                    SizedBox(height: 8.0),
                                    Text('Bulan',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13.0))
                                  ],
                                ),
                                SizedBox(
                                  width: mediaQueryData.size.width * 0.03,
                                ),
                                Column(
                                  children: <Widget>[
                                    Text("$jumlahtotal",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0)),
                                    SizedBox(height: 8.0),
                                    Text('Total',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13.0))
                                  ],
                                ),
                                SizedBox(
                                  width: mediaQueryData.size.width * 0.03,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _cardorange() {
    return FutureBuilder(
      future: jumlahAgenda(), // a previously-obtained Future<String> or null
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: cardBerita2(),
          );
        } else {
          return Container(
            child: shimmerantrian(),
          );
        }
      },
    );
  }

  // Widget _cardobiru() {
  //   return FutureBuilder(
  //     future: jumlahAgenda(), // a previously-obtained Future<String> or null
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         return Container(
  //           child: cardBerita(),
  //         );
  //       } else {
  //         return Container(
  //           child: shimmerantrian2(),
  //         );
  //       }
  //     },
  //   );
  // }

  Widget shimmerantrian() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.01,
        left: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.01,
        //bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Shimmer.fromColors(
        highlightColor: Colors.white,
        baseColor: Colors.grey[300],
        child: Column(
          children: [
            Container(
              width: mediaQueryData.size.width,
              height: mediaQueryData.size.height * 0.15,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            SizedBox(
              height: mediaQueryData.size.height * 0.01,
            ),
            Container(
              width: mediaQueryData.size.width,
              height: mediaQueryData.size.height * 0.1,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shimmerantrian2() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: new EdgeInsets.all(5.0),
      child: Shimmer.fromColors(
        highlightColor: Colors.white,
        baseColor: Colors.grey[300],
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height * 0.1,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
    );
  }

  Widget _janjiAll() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        // top: mediaQueryData.size.height * 0.3,
        left: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.01,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0.0, 5.0),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Material(
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/HalJanjiHariIniAll');
            },
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: mediaQueryData.size.height * 0.1,
                  width: mediaQueryData.size.height * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xFF44AEA5).withOpacity(0.2),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(15.0),
                    icon: Icon(Icons.list),
                    color: Color(0xFF44AEA5),
                    iconSize: 40.0,
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.03,
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Container(
                              margin: const EdgeInsets.only(
                                top: 10.0,
                                bottom: 5.0,
                              ),
                              child: new Text(
                                "Semua Janji",
                                style: new TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xFF44AEA5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: new Text(
                          "Lihat detail",
                          style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _janjiHariIni() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        // top: mediaQueryData.size.height * 0.3,
        left: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.01,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Container(
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
        child: Material(
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/HalJanjiHariIni');
            },
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: mediaQueryData.size.height * 0.1,
                  width: mediaQueryData.size.height * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xFF44AEA5).withOpacity(0.2),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(15.0),
                    icon: Icon(Icons.today),
                    color: Color(0xFF44AEA5),
                    iconSize: 40.0,
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.03,
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Container(
                              margin: const EdgeInsets.only(
                                top: 10.0,
                                bottom: 5.0,
                              ),
                              child: new Text(
                                "Janji Hari Ini",
                                style: new TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xFF44AEA5),
                                  fontWeight: FontWeight.bold,
                                  //fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: new Text(
                          "Lihat detail",
                          style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                            // fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
        ],
      ),
    );
  }

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
        top: mediaQueryData.size.height * 0.02,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Text(
        "Janji",
        style: new TextStyle(
          fontSize: 20.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
