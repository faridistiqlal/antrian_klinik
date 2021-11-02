import 'package:flutter/material.dart';
import 'package:antrian_dokter/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HalDataKeluarga extends StatefulWidget {
  @override
  _HalDataKeluargaState createState() => _HalDataKeluargaState();
}

class _HalDataKeluargaState extends State<HalDataKeluarga> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List dataJSON;
  var isloading = false;
  void dataKeluarga() async {
    setState(() {
      isloading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    String theUrl = getMyUrl.url + 'Pasien/GetDataKeluarga';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
      body: {
        "KK": pref.getString("KK"),
      },
    );
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
    dataKeluarga();
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
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      // top: mediaQueryData.size.height * 0.1,
                      left: mediaQueryData.size.height * 0.01,
                      right: mediaQueryData.size.height * 0.01,
                      // bottom: mediaQueryData.size.height * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: _text(),
                        ),
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
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: mediaQueryData.size.height * 0.20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      // top: mediaQueryData.size.height * 0.1,
                      left: mediaQueryData.size.height * 0.01,
                      right: mediaQueryData.size.height * 0.01,
                      // bottom: mediaQueryData.size.height * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: _text(),
                        ),
                        Expanded(
                          child: ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dataJSON == null ? 0 : dataJSON.length,
                            itemBuilder: (BuildContext context, int i) {
                              var status = dataJSON[i]["UrutKeluarga"];
                              if (status == '1') {
                                status = 'Ayah';
                              } else if (status == '2') {
                                status = 'Ibu';
                              } else {
                                status = 'Anak';
                              }
                              if (i == dataJSON.length) {
                                return Center();
                              } else {
                                if (dataJSON[i]["NoKK"] == 'NotFound') {
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
                                            "Tidak ada Keluarga",
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
                                    padding: new EdgeInsets.all(3.0),
                                    child: Container(
                                      // clipBehavior: Clip.antiAliasWithSaveLayer,
                                      // elevation: 1.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              offset: Offset(0.0, 5.0),
                                              blurRadius: 10.0),
                                        ],
                                      ),
                                      // color: Colors.white,
                                      child: Material(
                                        color: Colors.white,
                                        child: InkWell(
                                          onTap: () {},
                                          child: new Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Material(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                color: Colors.blueAccent[100]
                                                    .withOpacity(0.2),
                                                child: IconButton(
                                                  padding: EdgeInsets.all(15.0),
                                                  icon: Icon(Icons.people),
                                                  color: Colors.blueAccent[100],
                                                  iconSize: 50.0,
                                                  onPressed: () {
                                                    //Navigator.pushNamed(context, '/ListUser');
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    mediaQueryData.size.width *
                                                        0.02,
                                              ),
                                              new Expanded(
                                                child: new Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Row(
                                                      children: <Widget>[
                                                        new Expanded(
                                                          child: new Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 10.0,
                                                            ),
                                                            child: new Text(
                                                              dataJSON[i]
                                                                  ["Nama"],
                                                              style:
                                                                  new TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                //fontWeight: FontWeight.normal,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        new Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10.0),
                                                          child: new Text(
                                                            dataJSON[i]
                                                                ["Kelamin"],
                                                            style: new TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors
                                                                    .grey[600]),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    new Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 10.0),
                                                      child: new Row(
                                                        children: <Widget>[
                                                          new Text(
                                                            dataJSON[i]["NoRm"],
                                                            style:
                                                                new TextStyle(
                                                              color: Colors
                                                                  .grey[500],
                                                              fontSize: 14.0,
                                                            ),
                                                          ),
                                                          Container(
                                                              height: 10,
                                                              child: VerticalDivider(
                                                                  color: Colors
                                                                      .grey)),
                                                          new Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5.0),
                                                            child: new Text(
                                                              'Status : ' +
                                                                  status,
                                                              style: new TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                          .blueAccent[
                                                                      100],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
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
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget shimmerantrian() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.03,
        // left: mediaQueryData.size.height * 0.01,
        // right: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.01,
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
                height: mediaQueryData.size.height * 0.1,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
            ],
          ),
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

  Widget _text() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
        top: mediaQueryData.size.height * 0.02,
      ),
      child: Text(
        "Data Keluarga",
        style: new TextStyle(
            fontSize: 25.0,
            color: Colors.grey[800],
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
