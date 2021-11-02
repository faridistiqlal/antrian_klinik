import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';
import 'package:antrian_dokter/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';

class JanjiAKtif extends StatefulWidget {
  @override
  _JanjiAKtifState createState() => _JanjiAKtifState();
}

class _JanjiAKtifState extends State<JanjiAKtif> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List layananlist = List();
  List dataJSON;
  var isloading = false;
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

  void ambildatajanji() async {
    setState(() {
      isloading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    String theUrl = getMyUrl.url + 'appoiment/ongoing';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
      body: {
        "norm": pref.getString("Username"),
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

  void hapusJanji(idJanji) async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    String theUrl = getMyUrl.url + 'appoiment/delete';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
      body: {
        "id": idJanji,
      },
    );
    var result = json.decode(res.body);

    print(result);
    if (result['Status'] == 'Berhasil') {
      SnackBar snackBar = SnackBar(
        duration: Duration(seconds: 2),
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.delete,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: mediaQueryData.size.width * 0.01,
            ),
            Text(
              'Hapus berhasil',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.red,
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
        Duration(seconds: 1),
        () {
          Navigator.pushReplacementNamed(context, '/JanjiAKtif');
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();

    ambildatajanji();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
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
          // Center(child: CircularProgressIndicator())
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
                          child: _list(),
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

  Widget _text() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.02,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        // bottom: mediaQueryData.size.height * 0.02,
      ),
      child: Text(
        "Janji Hari Ini",
        style: new TextStyle(
          fontSize: 25.0,
          color: Colors.grey[800],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _list() {
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
                      "Tidak ada janji",
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
                    color: Colors.blueAccent[100],
                    // border: Border.all(
                    //   color: Colors.blueAccent[100],
                    // ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0.0, 5.0),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        child: SpinKitPouringHourglass(
                          color: Colors.white,
                          size: 50,
                        ),
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
                                      child:
                                          VerticalDivider(color: Colors.white)),
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
                                      'No. Antrian',
                                      style: new TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
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

            return Slidable(
              controller: slidableController,
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: _container(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Hapus',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    Alert(
                      style: alertStyle,
                      context: context,
                      type: AlertType.warning,
                      // desc: dataJSON[i]["nama_dokter"],
                      title: "Hapus Janji? ",
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
                            "Hapus",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () async {
                            hapusJanji(dataJSON[i]["id"]);
                            Navigator.pop(context);
                          },
                          color: Colors.red,
                        )
                      ],
                    ).show();
                  },
                ),
              ],
            );
          }
        }
      },
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

  Widget animasi() {
    return SpinKitPouringHourglass(
      color: Colors.green,
      size: 50,
    );
  }

  // Widget _listjanjiaktif() {
  //   MediaQueryData mediaQueryData = MediaQuery.of(context);

  //   return Padding(
  //     padding: EdgeInsets.only(
  //       top: mediaQueryData.size.height * 0.02,
  //       left: mediaQueryData.size.height * 0.02,
  //       right: mediaQueryData.size.height * 0.02,
  //       bottom: mediaQueryData.size.height * 0.02,
  //     ),
  //     child: Container(
  //       padding: EdgeInsets.all(mediaQueryData.size.height * 0.02),
  //       height: mediaQueryData.size.height * 0.15,
  //       decoration: BoxDecoration(
  //         color: Colors.teal[200],
  //         borderRadius: BorderRadius.all(Radius.circular(15.0)),
  //         boxShadow: [
  //           BoxShadow(
  //               color: Colors.black.withOpacity(0.1),
  //               offset: Offset(0.0, 5.0),
  //               blurRadius: 10.0),
  //         ],
  //       ),

  //       // color: Colors.greenAccent,

  //       child: new Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Container(
  //             margin: EdgeInsets.all(10),
  //             // color: Color(0xFF44AEA5).withOpacity(0.2),
  //             child: SpinKitPouringHourglass(
  //               color: Colors.white,
  //               size: 50,
  //             ),
  //           ),
  //           new Padding(
  //             padding:
  //                 new EdgeInsets.only(left: mediaQueryData.size.height * 0.01),
  //           ),
  //           new Expanded(
  //             child: new Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 new Row(
  //                   children: <Widget>[
  //                     new Expanded(
  //                       child: new Container(
  //                         margin: const EdgeInsets.only(top: 3.0, bottom: 2.0),
  //                         child: new Text(
  //                           '${widget.dokter}',
  //                           style: new TextStyle(
  //                             fontSize: 18.0,
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.bold,
  //                             //fontWeight: FontWeight.normal,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     new Container(
  //                       margin: const EdgeInsets.only(right: 10.0),
  //                       child: new Text(
  //                         '${widget.layanan}',
  //                         style: new TextStyle(
  //                           fontSize: 14.0,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Divider(
  //                   color: Colors.white,
  //                 ),
  //                 new Container(
  //                   child: new Row(
  //                     children: <Widget>[
  //                       new Text(
  //                         'Tanggal : '
  //                         '${widget.tanggal}',
  //                         style: new TextStyle(
  //                           fontSize: 13.0,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                       Container(
  //                           height: 10,
  //                           child: VerticalDivider(color: Colors.white)),
  //                       new Container(
  //                         margin: const EdgeInsets.only(left: 5.0),
  //                         child: new Text(
  //                           '${widget.jam}',
  //                           style: new TextStyle(
  //                             fontSize: 13.0,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 new Container(
  //                   margin: EdgeInsets.only(
  //                     right: mediaQueryData.size.width * 0.1,
  //                     top: mediaQueryData.size.height * 0.01,
  //                   ),
  //                   child: new Text(
  //                     'Daftar : ' + '${widget.daftar}',
  //                     style: new TextStyle(
  //                       fontSize: 13.0, color: Colors.white,
  //                       // fontWeight: FontWeight.bold,
  //                     ),
  //                     maxLines: 2,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
