import 'package:flutter/material.dart';
import 'package:antrian_dokter/data.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HalRiwayatPasien extends StatefulWidget {
  @override
  _HalRiwayatPasienState createState() => _HalRiwayatPasienState();
}

class _HalRiwayatPasienState extends State<HalRiwayatPasien> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SlidableController slidableController = SlidableController();
  List dataJSON;
  var isloading = false;

  void ambilriwayat() async {
    setState(() {
      isloading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    String theUrl = getMyUrl.url + 'appoiment/selesai';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
      body: {
        "norm": pref.getString("Username"),
      },
    );
    // var alljadwal = json.decode(res.body);
    // print(alljadwal);
    if (res.statusCode == 200) {
      this.setState(
        () {
          dataJSON = json.decode(res.body);
        },
      );
      setState(() {
        isloading = false;
      });
    }
    print(dataJSON);
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
      body: isloading
          ? Stack(
              children: <Widget>[
                _logo(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _text(),
                        shimmerantrian(),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: <Widget>[
                _logo(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _text(),
                        Expanded(
                          child: _riwayat(),
                        )
                      ],
                    ),
                  ),
                ),
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
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        // bottom: mediaQueryData.size.height * 0.01,
        top: mediaQueryData.size.height * 0.02,
      ),
      child: Text(
        "Riwayat Janji",
        style: new TextStyle(
            fontSize: 28.0,
            color: Colors.grey[800],
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _riwayat() {
    // MediaQueryData mediaQueryData = MediaQuery.of(context);
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
                      "Tidak ada Riwayat",
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
              MediaQueryData mediaQueryData = MediaQuery.of(context);
              return Padding(
                padding: EdgeInsets.only(
                  // top: mediaQueryData.size.height * 0.02,
                  left: mediaQueryData.size.height * 0.02,
                  right: mediaQueryData.size.height * 0.02,
                  bottom: mediaQueryData.size.height * 0.01,
                ),
                child: Container(
                  padding: EdgeInsets.all(mediaQueryData.size.height * 0.02),
                  height: mediaQueryData.size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    // boxShadow: [
                    //   BoxShadow(
                    //       color: Colors.black.withOpacity(0.1),
                    //       offset: Offset(0.0, 1.0),
                    //       blurRadius: 1.0),
                    // ],
                  ),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        padding: EdgeInsets.all(15.0),
                        icon: Icon(Icons.history),
                        color: Colors.black54,
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
                                        color: Colors.black54,
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
                                      color: Colors.black54,
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
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Container(
                                      height: 10,
                                      child:
                                          VerticalDivider(color: Colors.white)),
                                  new Container(
                                    margin: const EdgeInsets.only(left: 5.0),
                                    child: new Text(
                                      dataJSON[i]["jam"],
                                      style: new TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
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
                                  fontSize: 13.0, color: Colors.black54,
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
                                      'No. Antrian',
                                      style: new TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black54,
                                        // fontWeight: FontWeight.bold,
                                        //fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                                new Container(
                                  margin: const EdgeInsets.only(right: 10.0),
                                  child: new Text(
                                    dataJSON[i]["noantrian"],
                                    style: new TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black54,
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

            return Slidable(
              controller: slidableController,
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: _container(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Rating?',
                  color: Colors.orange[800],
                  icon: Icons.star,
                  onTap: () {
                    Navigator.pushNamed(context, '/HalRating');
                    // Alert(
                    //   style: alertStyle,
                    //   context: context,
                    //   type: AlertType.warning,
                    //   // desc: dataJSON[i]["nama_dokter"],
                    //   title: "Hapus Janji? ",
                    //   buttons: [
                    //     DialogButton(
                    //       child: Text(
                    //         "Tidak",
                    //         style: TextStyle(color: Colors.white, fontSize: 16),
                    //       ),
                    //       onPressed: () => Navigator.pop(context),
                    //       color: Colors.green,
                    //     ),
                    //     DialogButton(
                    //       child: Text(
                    //         "Hapus",
                    //         style: TextStyle(color: Colors.white, fontSize: 16),
                    //       ),
                    //       onPressed: () async {
                    //         // hapusJanji(dataJSON[i]["id"]);
                    //         Navigator.pop(context);
                    //       },
                    //       color: Colors.red,
                    //     )
                    //   ],
                    // ).show();
                  },
                ),
              ],
            );
          }
        }
      },
    );
  }

  Widget shimmerantrian() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.02,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Padding(
        padding: new EdgeInsets.all(5.0),
        child: Shimmer.fromColors(
          highlightColor: Colors.white,
          baseColor: Colors.grey[300],
          child: Column(
            children: <Widget>[
              Container(
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height * 0.2,
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
                height: mediaQueryData.size.height * 0.2,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
