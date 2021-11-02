import 'package:flutter/material.dart';
import 'package:antrian_dokter/data.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';

class HalJanjiHariIni extends StatefulWidget {
  @override
  _HalJanjiHariIniState createState() => _HalJanjiHariIniState();
}

class _HalJanjiHariIniState extends State<HalJanjiHariIni> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SlidableController slidableController = SlidableController();
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
      alertAlignment: Alignment.center);
  List dataJSON;

  void ambilriwayat() async {
    String theUrl = getMyUrl.url + 'appoiment/HariIni';
    var res = await http.get(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
    );

    this.setState(
      () {
        dataJSON = json.decode(res.body);
      },
    );
    print(dataJSON);
  }

  void ubahselesai(norm, antrian, tgl) async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    String theUrl = getMyUrl.url + 'appoiment/RubahSelesai';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "NoAntrian": antrian,
        "NoRm": norm,
        "TanggalAppoiment": tgl,
      },
    );
    var ubahselesai = json.decode(res.body);
    print(ubahselesai);
    print(antrian);
    print(norm);
    print(tgl);
    if (ubahselesai['Status'] == 'Berhasil') {
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
              'Janji sudah selesai',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            // Navigator.pushReplacementNamed(context, '/ListLayanan');
            print('Berhasil');
          },
        ),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
      await Future.delayed(
        Duration(seconds: 2),
        () {
          Navigator.pushReplacementNamed(context, '/HalJanjiHariIni');
        },
      );
    }
  }

  void kembaliantri(norm, antrian, tgl) async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    String theUrl = getMyUrl.url + 'appoiment/kembaliantri';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "NoAntrian": antrian,
        "NoRm": norm,
        "TanggalAppoiment": tgl,
      },
    );
    var ubahselesai = json.decode(res.body);
    print(ubahselesai);
    print(antrian);
    print(norm);
    print(tgl);
    if (ubahselesai['Status'] == 'Berhasil') {
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
              'Janji kembali aktif',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            // Navigator.pushReplacementNamed(context, '/ListLayanan');
            print('Berhasil');
          },
        ),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
      await Future.delayed(
        Duration(seconds: 2),
        () {
          Navigator.pushReplacementNamed(context, '/HalJanjiHariIni');
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    ambilriwayat();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
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
                _text(),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // _text(),
                new Padding(
                  padding: new EdgeInsets.only(
                      top: mediaQueryData.size.height * 0.01),
                ),
                Expanded(
                  child: _riwayat(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _text() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.08,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Janji Hari Ini",
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

  Widget _riwayat() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: dataJSON == null ? 0 : dataJSON.length,
      itemBuilder: (BuildContext context, int i) {
        if (i == dataJSON.length) {
          return Center();
        } else {
          if (dataJSON[i]["noantrian"] == 'NotFound') {
            return Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    new Icon(
                      Icons.calendar_today,
                      size: 150,
                      color: Colors.grey[300],
                    ),
                    Text(
                      "Tidak ada Janji",
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
            Widget _container() {
              if (dataJSON[i]["status"] == '0') {
                return Padding(
                  padding: EdgeInsets.only(
                    // top: mediaQueryData.size.height * 0.02,
                    left: mediaQueryData.size.height * 0.02,
                    right: mediaQueryData.size.height * 0.02,
                    bottom: mediaQueryData.size.height * 0.005,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(mediaQueryData.size.height * 0.02),
                    height: mediaQueryData.size.height * 0.2,
                    decoration: BoxDecoration(
                      color: Color(0xFF44AEA5),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0.0, 5.0),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.all(15.0),
                          icon: Icon(Icons.access_time),
                          color: Colors.white,
                          iconSize: 30.0,
                          onPressed: () {
                            //Navigator.pushNamed(context, '/ListUser');
                          },
                        ),
                        new Padding(
                          padding: new EdgeInsets.only(
                              left: mediaQueryData.size.height * 0.01),
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
                                          top: 3.0, bottom: 2.0),
                                      child: new Text(
                                        dataJSON[i]["dokter"],
                                        style: new TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          //fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    margin: const EdgeInsets.only(right: 10.0),
                                    child: new Text(
                                      dataJSON[i]["layanan"],
                                      style: new TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              new Container(
                                child: new Row(
                                  children: <Widget>[
                                    new Text(
                                      'Tanggal : ' + dataJSON[i]["tanggal"],
                                      style: new TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                        height: 10,
                                        child: VerticalDivider(
                                            color: Colors.white)),
                                    new Container(
                                      margin: const EdgeInsets.only(left: 5.0),
                                      child: new Text(
                                        dataJSON[i]["jam"],
                                        style: new TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              new Container(
                                margin: EdgeInsets.only(
                                  right: mediaQueryData.size.width * 0.1,
                                  top: mediaQueryData.size.height * 0.01,
                                ),
                                child: new Text(
                                  'Daftar : ' + dataJSON[i]["daftar"],
                                  style: new TextStyle(
                                    fontSize: 13.0, color: Colors.white,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Container(
                                      child: new Text(
                                        dataJSON[i]["norm"],
                                        style: new TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          //fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    margin: const EdgeInsets.only(right: 10.0),
                                    child: new Text(
                                      'No. ' + dataJSON[i]["noantrian"],
                                      style: new TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(
                    // top: mediaQueryData.size.height * 0.02,
                    left: mediaQueryData.size.height * 0.02,
                    right: mediaQueryData.size.height * 0.02,
                    bottom: mediaQueryData.size.height * 0.005,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(mediaQueryData.size.height * 0.02),
                    height: mediaQueryData.size.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0.0, 5.0),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.all(15.0),
                          icon: Icon(Icons.done),
                          color: Colors.white,
                          iconSize: 30.0,
                          onPressed: () {
                            //Navigator.pushNamed(context, '/ListUser');
                          },
                        ),
                        new Padding(
                          padding: new EdgeInsets.only(
                              left: mediaQueryData.size.height * 0.01),
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
                                          top: 3.0, bottom: 2.0),
                                      child: new Text(
                                        dataJSON[i]["dokter"],
                                        style: new TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          //fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    margin: const EdgeInsets.only(right: 10.0),
                                    child: new Text(
                                      dataJSON[i]["layanan"],
                                      style: new TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              new Container(
                                child: new Row(
                                  children: <Widget>[
                                    new Text(
                                      'Tanggal : ' + dataJSON[i]["tanggal"],
                                      style: new TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                        height: 10,
                                        child: VerticalDivider(
                                            color: Colors.white)),
                                    new Container(
                                      margin: const EdgeInsets.only(left: 5.0),
                                      child: new Text(
                                        dataJSON[i]["jam"],
                                        style: new TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              new Container(
                                margin: EdgeInsets.only(
                                  right: mediaQueryData.size.width * 0.1,
                                  top: mediaQueryData.size.height * 0.01,
                                ),
                                child: new Text(
                                  'Daftar : ' + dataJSON[i]["daftar"],
                                  style: new TextStyle(
                                    fontSize: 13.0, color: Colors.white,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Container(
                                      child: new Text(
                                        dataJSON[i]["norm"],
                                        style: new TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          //fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    margin: const EdgeInsets.only(right: 10.0),
                                    child: new Text(
                                      'No. ' + dataJSON[i]["noantrian"],
                                      style: new TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }

            if (dataJSON[i]["status"] == '0') {
              return Slidable(
                controller: slidableController,
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: _container(),
                actions: <Widget>[],
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Selesai?',
                    color: Colors.green,
                    icon: Icons.done,
                    onTap: () {
                      Alert(
                        style: alertStyle,
                        context: context,
                        type: AlertType.warning,
                        // desc: dataJSON[i]["nama_dokter"],
                        title: "Ubah ke selesai? ",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Tidak",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () => Navigator.pop(context),
                            color: Colors.red,
                          ),
                          DialogButton(
                            child: Text(
                              "Selesai",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () async {
                              ubahselesai(
                                  dataJSON[i]["norm"],
                                  dataJSON[i]["noantrian"],
                                  dataJSON[i]["tanggalrubah"]);
                              Navigator.pop(context);
                            },
                            color: Colors.green,
                          )
                        ],
                      ).show();
                    },
                  ),
                ],
              );
            } else {
              return Slidable(
                controller: slidableController,
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: _container(),
                actions: <Widget>[],
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Aktif',
                    color: Colors.red,
                    icon: Icons.undo,
                    onTap: () {
                      Alert(
                        style: alertStyle,
                        context: context,
                        type: AlertType.warning,
                        // desc: dataJSON[i]["nama_dokter"],
                        title: "Kembalikan ke antrean? ",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Tidak",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () => Navigator.pop(context),
                            color: Colors.red,
                          ),
                          DialogButton(
                            child: Text(
                              "Ya",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () async {
                              kembaliantri(
                                  dataJSON[i]["norm"],
                                  dataJSON[i]["noantrian"],
                                  dataJSON[i]["tanggalrubah"]);
                              Navigator.pop(context);
                            },
                            color: Colors.green,
                          )
                        ],
                      ).show();
                    },
                  ),
                ],
              );
            }
          }
        }
      },
    );
  }
}
