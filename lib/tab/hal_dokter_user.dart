import 'package:antrian_dokter/halaman/hal_rating_pasien.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http; //api
//import 'dart:async'; // api syn
import 'dart:convert';
import 'package:antrian_dokter/data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';

class ListDokterPasien extends StatefulWidget {
  @override
  _ListDokterPasienState createState() => _ListDokterPasienState();
}

class _ListDokterPasienState extends State<ListDokterPasien> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List dataJSON;
  List jadwallist = List();
  final SlidableController slidableController = SlidableController();
  var isloading = false;

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

  void ambildatadokter() async {
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
        this.setState(
          () {
            dataJSON = json.decode(res.body);
          },
        );
        setState(() {
          isloading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    ambildatadokter();
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
                          Expanded(
                            child: ListView.builder(
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
                                          top:
                                              mediaQueryData.size.height * 0.2),
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
                                    Widget _container() {
                                      return Container(
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
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  offset: Offset(0.0, 5.0),
                                                  blurRadius: 10.0),
                                            ],
                                          ),
                                          // color: Colors.white,
                                          child: Material(
                                            child: InkWell(
                                              onTap: () {},
                                              child: new Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9.0),
                                                    // margin: const EdgeInsets.only(right: 15.0),
                                                    // width: 120.0,
                                                    // height: 100.0,
                                                    child: CachedNetworkImage(
                                                      imageUrl: dataJSON[i]
                                                          ["Foto"],
                                                      placeholder: (context,
                                                              url) =>
                                                          Shimmer.fromColors(
                                                        highlightColor:
                                                            Colors.white,
                                                        baseColor:
                                                            Colors.grey[300],
                                                        child: Container(
                                                          height: mediaQueryData
                                                                  .size.height *
                                                              0.12,
                                                          width: mediaQueryData
                                                                  .size.height *
                                                              0.12,
                                                        ),
                                                      ),
                                                      fit: BoxFit.cover,
                                                      height: mediaQueryData
                                                              .size.height *
                                                          0.12,
                                                      width: mediaQueryData
                                                              .size.height *
                                                          0.12,
                                                    ),
                                                  ),
                                                  new Padding(
                                                    padding:
                                                        new EdgeInsets.only(
                                                            left: mediaQueryData
                                                                    .size
                                                                    .height *
                                                                0.01),
                                                  ),
                                                  new Expanded(
                                                    child: new Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        new Row(
                                                          children: <Widget>[
                                                            new Expanded(
                                                              child:
                                                                  new Container(
                                                                margin: const EdgeInsets
                                                                        .only(
                                                                    top: 5.0,
                                                                    bottom:
                                                                        10.0),
                                                                child: new Text(
                                                                  dataJSON[i][
                                                                      "NamaDokter"],
                                                                  style:
                                                                      new TextStyle(
                                                                    fontSize:
                                                                        15.0,
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
                                                                      right:
                                                                          10.0),
                                                              child: new Text(
                                                                dataJSON[i]["Rating"]
                                                                        .substring(
                                                                            0,
                                                                            3) +
                                                                    ' Rating',
                                                                style: new TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                    color: Colors
                                                                            .grey[
                                                                        600]),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        new Container(
                                                          child: new Row(
                                                            children: <Widget>[
                                                              new Text(
                                                                dataJSON[i]
                                                                    ["Karir"],
                                                                style:
                                                                    new TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  color: Colors
                                                                      .black54,
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
                                                                        left:
                                                                            5.0),
                                                                child: new Text(
                                                                  dataJSON[i][
                                                                      "Spesialis"],
                                                                  style:
                                                                      new TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        new Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                            right:
                                                                mediaQueryData
                                                                        .size
                                                                        .width *
                                                                    0.1,
                                                            top: mediaQueryData
                                                                    .size
                                                                    .height *
                                                                0.01,
                                                          ),
                                                          child: new Text(
                                                            dataJSON[i]["Moto"],
                                                            style: new TextStyle(
                                                                fontSize: 11.0,
                                                                color: Colors
                                                                    .grey[500]
                                                                // fontWeight: FontWeight.bold,
                                                                ),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                            Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                builder: (context) =>
                                                    new HalRating(
                                                  idDokter: dataJSON[i]
                                                      ["IdDokter"],
                                                  nama: dataJSON[i]
                                                      ["NamaDokter"],
                                                  foto: dataJSON[i]["Foto"],
                                                ),
                                              ),
                                            );

                                            // Navigator.pushNamed(context, '/HalRating');
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
                            ),
                          ),
                        ]),
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
                height: mediaQueryData.size.height * 0.12,
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
                height: mediaQueryData.size.height * 0.12,
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
        left: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.02,
        // bottom: mediaQueryData.size.height * 0.01,
        top: mediaQueryData.size.height * 0.02,
      ),
      child: Text(
        "Dokter Klinik",
        style: new TextStyle(
            fontSize: 25.0,
            color: Colors.grey[800],
            fontWeight: FontWeight.bold),
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
}
