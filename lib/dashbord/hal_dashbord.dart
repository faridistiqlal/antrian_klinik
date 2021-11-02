import 'dart:ui';
import 'package:antrian_dokter/halaman/detail_dokter.dart';
import 'package:antrian_dokter/halaman/hal_login.dart';
import 'package:antrian_dokter/tambah/tambah_anak.dart';
import 'package:antrian_dokter/tambah/tambah_pasangan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:antrian_dokter/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shimmer/shimmer.dart';

class Dashbord extends StatefulWidget {
  @override
  _DashbordState createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  String nama = "";
  String norm = "";
  String iduser = "";
  String statusPasien = '';
  List dataJSON;

  String menunggu;
  String selesai;

  var isloading = false;

  var getNoKK;
  void initState() {
    super.initState();
    _cekLogin();
    _cekUser();
    _getKK();
    ambildatadokter();
    antrianpasien();
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

  void lihatJanji() async {
    String theUrl = getMyUrl.url + 'appoiment/ongoing';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
      body: {
        "norm": norm,
      },
    );
    var responsBody = json.decode(res.body);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => JanjiAKtif(
    //       layanan: responsBody['layanan'],
    //       dokter: responsBody['dokter'],
    //       tanggal: responsBody['tanggal'],
    //       jam: responsBody['jam'],
    //       daftar: responsBody['daftar'],
    //     ),
    //   ),
    // );
    Navigator.pushNamed(context, '/JanjiAKtif');

    print(responsBody);
    return responsBody;
  }

  Future antrianpasien() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    String theUrl = getMyUrl.url + 'appoiment/antrian';
    final response = await http.get(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
    );
    var antrian = json.decode(response.body);
    print(antrian);
    if (this.mounted) {
      setState(
        () {
          menunggu = antrian['Menunggu'];
          selesai = antrian['Selesai'];
        },
      );
    }
    return antrian;
  }

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

    setState(
      () {
        nama = pref.getString("Nama");
        norm = pref.getString("Username");
        iduser = pref.getString("IdUser");
      },
    );
  }

  Future ambildatadokter() async {
    setState(() {
      isloading = true;
    });
    String theUrl = getMyUrl.url + 'Dokter/GetAllData';
    var res = await http.get(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
    );
    var alldokter = json.decode(res.body);
    print(alldokter);
    if (res.statusCode == 200) {
      if (this.mounted) {
        setState(
          () {
            dataJSON = json.decode(res.body);
          },
        );
        setState(() {
          isloading = false;
        });
      }
    }
    //return alldokter;
  }

  void _getKK() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String theUrl = getMyUrl.url + 'Pasien/GetKK';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
      body: {
        "NoRm": pref.getString("Username"),
      },
    );
    if (this.mounted) {
      setState(
        () {
          statusPasien = pref.getString("StatusPasien");
          getNoKK = json.decode(res.body);
        },
      );
    }
    print(getNoKK['KK']);
    pref.setString('KK', getNoKK['KK']);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      floatingActionButton: buildSpeedDial(),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: _logo(),
        centerTitle: true,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.person),
        //     color: Colors.white,
        //     onPressed: () async {
        //       // Navigator.pushNamed(context, '/HalCek');
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
              color: Colors.blueAccent[100],
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
                margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[50],
                ),
                child: Column(
                  children: <Widget>[],
                ),
              ),
              _texttop(),
              _menuTop(),
              // _menuMid(),
              _menuBottom(),
              _textbottom(),

              _getDokter(),
              // cardBerita2(),
              _futureCard(),
              // _futureCardDokter(),
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
          "  Antrian Klinik",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  SpeedDial buildSpeedDial() {
    if (statusPasien == 'Ibu' || statusPasien == 'Ayah') {
      return SpeedDial(
        //marginRight: 190,
        //marginBottom: 100,
        //foregroundColor: Colors.green,
        //animatedIcon: AnimatedIcons.menu_close,
        //animatedIconTheme: IconThemeData(color: Colors.blue),
        icon: Icons.person_add,
        activeIcon: Icons.arrow_drop_down,
        backgroundColor: Colors.green,
        overlayColor: Colors.grey[50],
        children: [
          SpeedDialChild(
            child: Icon(Icons.pregnant_woman),
            label: "Tambah Anak",
            labelBackgroundColor: Colors.white,
            backgroundColor: Colors.orange,
            onTap: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              //Navigator.pushNamed(context, '/TambahAnak');
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) => new TambahAnak(
                    kk: pref.getString("KK"),
                    hp: pref.getString("Hp"),
                  ),
                ),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.shopping_basket),
            label: "Tambah Pasangan",
            labelBackgroundColor: Colors.white,
            backgroundColor: Colors.blue,
            onTap: () async {
              //Navigator.pushNamed(context, '/TambahPasangan');
              SharedPreferences pref = await SharedPreferences.getInstance();
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) => new TambahPasangan(
                    kk: pref.getString("KK"),
                  ),
                ),
              );
            },
          ),
        ],
      );
    } else {
      return SpeedDial(
        //marginRight: 190,
        //marginBottom: 100,
        //foregroundColor: Colors.green,
        //animatedIcon: AnimatedIcons.menu_close,
        //animatedIconTheme: IconThemeData(color: Colors.blue),
        icon: Icons.person_add,
        activeIcon: Icons.arrow_drop_down,
        backgroundColor: Colors.green,
        overlayColor: Colors.grey[50],
        children: [
          SpeedDialChild(
            child: Icon(Icons.people),
            label: "Tambah Orangtua",
            labelBackgroundColor: Colors.white,
            backgroundColor: Colors.red,
            onTap: () {
              Navigator.pushNamed(context, '/TambahOrtu');
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.local_activity),
            label: "Rubah Menikah",
            labelBackgroundColor: Colors.white,
            backgroundColor: Colors.orange,
            onTap: () async {
              Navigator.pushNamed(context, '/RubahMenikah');
            },
          ),
        ],
      );
    }
  }

  Widget _user() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.all(mediaQueryData.size.height * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Halo, ' + nama,
            style: new TextStyle(
                fontSize: 25.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          // IconButton(
          //   icon: Icon(
          //     Icons.credit_card,
          //     size: 30,
          //   ),
          //   color: Colors.white,
          //   onPressed: () async {
          //     SharedPreferences pref = await SharedPreferences.getInstance();
          //     pref.clear();
          //     _cekLogout();
          //   },
          // )
        ],
      ),
    );
  }

  Widget _menuTop() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.12,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.02,
      ),
      child: Container(
        padding: EdgeInsets.all(mediaQueryData.size.height * 0.02),
        height: mediaQueryData.size.height * 0.15,
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
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.green.withOpacity(0.2),
                      child: IconButton(
                        padding:
                            EdgeInsets.all(mediaQueryData.size.height * 0.017),
                        icon: Icon(Icons.history),
                        color: Colors.green,
                        iconSize: 30.0,
                        onPressed: () {
                          Navigator.pushNamed(context, '/HalRiwayatPasien');
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: mediaQueryData.size.height * 0.01,
                      ),
                      child: Text(
                        'Riwayat',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.orange.withOpacity(0.2),
                      child: IconButton(
                        padding:
                            EdgeInsets.all(mediaQueryData.size.height * 0.017),
                        icon: Icon(Icons.airline_seat_flat_angled),
                        color: Colors.orange,
                        iconSize: 30.0,
                        onPressed: () {
                          Navigator.pushNamed(context, '/HalLayanan');
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: mediaQueryData.size.height * 0.01,
                      ),
                      child: Text(
                        'Layanan',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.red.withOpacity(0.2),
                      child: IconButton(
                        padding:
                            EdgeInsets.all(mediaQueryData.size.height * 0.017),
                        icon: Icon(Icons.people),
                        color: Colors.red,
                        iconSize: 30.0,
                        onPressed: () {
                          Navigator.pushNamed(context, '/HalDataKeluarga');
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: mediaQueryData.size.height * 0.01,
                      ),
                      child: Text(
                        'Keluarga',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.blue.withOpacity(0.2),
                      child: IconButton(
                        padding:
                            EdgeInsets.all(mediaQueryData.size.height * 0.017),
                        icon: Icon(Icons.access_time),
                        color: Colors.blue,
                        iconSize: 30.0,
                        onPressed: () async {
                          Navigator.pushNamed(context, '/HalJadwalDokter');
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: mediaQueryData.size.height * 0.01,
                      ),
                      child: Text(
                        'Jadwal',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12.0,
                        ),
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

  Widget _futureCard() {
    return FutureBuilder(
      future: antrianpasien(), // a previously-obtained Future<String> or null
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

  Widget _futureCardDokter() {
    return FutureBuilder(
      future: ambildatadokter(), // a previously-obtained Future<String> or null
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: _getDokter(),
          );
        } else {
          return Container(
            child: shimmerantrian(),
          );
        }
      },
    );
  }

  Widget cardBerita2() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.43,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Padding(
        padding: new EdgeInsets.all(5.0),
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height * 0.15,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            // boxShadow: [
            //   BoxShadow(
            //       color: Colors.black.withOpacity(0.1),
            //       offset: Offset(0.0, 3.0),
            //       blurRadius: 15.0)
            // ],
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
                          "Menunggu",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Antrian Aktif ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                        Text(
                          "$menunggu",
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
                          "Selesai",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Antrian Selesai ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                        Text(
                          "$selesai",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 50.0,
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
    );
  }

  Widget shimmerantrian() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.43,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Padding(
        padding: new EdgeInsets.all(5.0),
        child: Shimmer.fromColors(
          highlightColor: Colors.white,
          baseColor: Colors.grey[300],
          child: Container(
            width: mediaQueryData.size.width,
            height: mediaQueryData.size.height * 0.15,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget shimmerdokter() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.64,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Padding(
        padding: new EdgeInsets.all(5.0),
        child: Shimmer.fromColors(
          highlightColor: Colors.white,
          baseColor: Colors.grey[300],
          child: Row(
            children: <Widget>[
              Container(
                width: mediaQueryData.size.width * 0.5,
                height: mediaQueryData.size.height * 0.12,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              SizedBox(
                width: mediaQueryData.size.height * 0.01,
              ),
              Container(
                width: mediaQueryData.size.width * 0.37,
                height: mediaQueryData.size.height * 0.12,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
        padding: EdgeInsets.only(
          top: mediaQueryData.size.height * 0.01,
          // left: mediaQueryData.size.height * 0.01,
          // right: mediaQueryData.size.height * 0.01,
          // bottom: mediaQueryData.size.height * 0.02,
        ),
        child: CircularProgressIndicator(backgroundColor: Colors.red));
  }

  Widget _getDokter() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return isloading
        ? Container(
            child: shimmerdokter(),
          )
        : Padding(
            padding: EdgeInsets.only(
              top: mediaQueryData.size.height * 0.64,
              left: mediaQueryData.size.height * 0.02,
              right: mediaQueryData.size.height * 0.02,
              bottom: mediaQueryData.size.height * 0.01,
            ),
            child: SizedBox(
              height: mediaQueryData.size.height * 0.13,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: dataJSON == null ? 0 : dataJSON.length,
                itemBuilder: (BuildContext context, int i) {
                  if (i == dataJSON.length) {
                    return _buildProgressIndicator();
                  } else {
                    if (dataJSON[i]["IdDokter"] == 'NotFound') {
                      return Container(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.2),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              new Icon(
                                Icons.calendar_today,
                                size: 150,
                                color: Colors.grey[300],
                              ),
                              Text(
                                "Tidak Dokter",
                                style: new TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.grey[300],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return new Container(
                        width: mediaQueryData.size.width * 0.55,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          elevation: 1,
                          child: InkWell(
                            onTap: () {
                              // Navigator.pushNamed(context, '/DetailDokter');

                              Navigator.of(context).push(
                                new MaterialPageRoute(
                                  builder: (context) => new DetailDokter(
                                    vNamaDokter: dataJSON[i]["NamaDokter"],
                                    vSpesialis: dataJSON[i]["Spesialis"],
                                    vMoto: dataJSON[i]["Moto"],
                                    vKarir: dataJSON[i]["Karir"],
                                    vJumlahRate: dataJSON[i]["JumlahRate"],
                                    vFoto: dataJSON[i]["Foto"],
                                    vRating: dataJSON[i]["Rating"],
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new ClipRRect(
                                  borderRadius: BorderRadius.circular(9.0),
                                  child: CachedNetworkImage(
                                    imageUrl: dataJSON[i]["Foto"],
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      highlightColor: Colors.white,
                                      baseColor: Colors.grey[300],
                                      child: Container(
                                        height:
                                            mediaQueryData.size.height * 0.12,
                                        width:
                                            mediaQueryData.size.height * 0.12,
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                    height: mediaQueryData.size.height * 0.12,
                                    width: mediaQueryData.size.height * 0.12,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top:
                                              mediaQueryData.size.height * 0.01,
                                          left:
                                              mediaQueryData.size.height * 0.01,
                                          right:
                                              mediaQueryData.size.height * 0.01,
                                          // bottom: mediaQueryData.size.height * 0.02,
                                        ),
                                        child: new Text(
                                          dataJSON[i]["NamaDokter"],
                                          style: new TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            //fontWeight: FontWeight.normal,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top:
                                              mediaQueryData.size.height * 0.01,
                                          left:
                                              mediaQueryData.size.height * 0.01,
                                          right:
                                              mediaQueryData.size.height * 0.01,
                                          // bottom: mediaQueryData.size.height * 0.02,
                                        ),
                                        child: new Text(
                                          dataJSON[i]["Spesialis"],
                                          style: new TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top:
                                              mediaQueryData.size.height * 0.01,
                                          left:
                                              mediaQueryData.size.height * 0.01,
                                          right:
                                              mediaQueryData.size.height * 0.01,
                                          // bottom: mediaQueryData.size.height * 0.02,
                                        ),
                                        child: SizedBox(
                                          height:
                                              mediaQueryData.size.height * 0.03,
                                          width:
                                              mediaQueryData.size.width * 0.19,
                                          child: FlatButton.icon(
                                            icon: Icon(
                                              Icons.star,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              dataJSON[i]["Rating"]
                                                  .substring(0, 3),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            color: Colors.orange,
                                            textColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      15.0),
                                            ),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          );
  }

  // ignore: unused_element
  Widget _textbottom() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.61,
        left: mediaQueryData.size.height * 0.03,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Text(
        "Dokter",
        style: new TextStyle(
            fontSize: 18.0, color: Colors.black54, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _texttop() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.29,
        left: mediaQueryData.size.height * 0.03,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Text(
        "Antrian",
        style: new TextStyle(
            fontSize: 18.0, color: Colors.black54, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _menuBottom() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.33,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      // child: Container(
      // padding: EdgeInsets.all(mediaQueryData.size.height * 0.01),
      // height: mediaQueryData.size.height * 0.12,
      // width: mediaQueryData.size.width,
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.all(Radius.circular(15.0)),
      //   boxShadow: [
      //     BoxShadow(
      //         color: Colors.black.withOpacity(0.1),
      //         offset: Offset(0.0, 5.0),
      //         blurRadius: 10.0),
      //   ],
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            color: Colors.blueAccent[100],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
            child: InkWell(
              onTap: () async {
                lihatJanji();
                // Navigator.pushNamed(context, '/JanjiAKtif');
              },
              child: ListTile(
                leading: Material(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.white,
                  child: IconButton(
                    padding: EdgeInsets.all(15.0),
                    icon: Icon(Icons.calendar_today),
                    color: Colors.blueAccent[100],
                    iconSize: 25.0,
                    onPressed: () {
                      //Navigator.pushNamed(context, '/HalamanBeritaadmin');
                    },
                  ),
                ),
                subtitle: new Text(
                  "Detail janji hari ini",
                  style: new TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
                title: new Text(
                  "Janji",
                  style: new TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
