import 'package:antrian_dokter/edit/edit_dokter.dart';
import 'package:antrian_dokter/halaman/detail_dokter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';
import 'package:antrian_dokter/data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ListDokter extends StatefulWidget {
  @override
  _ListDokterState createState() => _ListDokterState();
}

class _ListDokterState extends State<ListDokter> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List dataJSON;
  List jadwallist = List();
  final SlidableController slidableController = SlidableController();
  // ignore: missing_return
  bool isLoading = false;
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

  // ignore: missing_return
  Future<String> ambildatadokter() async {
    if (!isLoading) {
      setState(
        () {
          isLoading = true;
        },
      );
      String theUrl = getMyUrl.url + 'Dokter/GetAllData';
      var res = await http.get(
        Uri.encodeFull(theUrl),
        headers: {"Accept": "application/json"},
      );
      var alldokter = json.decode(res.body);
      print(alldokter);
      this.setState(
        () {
          isLoading = false;
          dataJSON = json.decode(res.body);
        },
      );
    }
  }

  void hapusdokter(dokterlist) async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    String theUrl = getMyUrl.url + 'Dokter/DeleteData';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "id": dokterlist,
      },
    );
    var deleted = json.decode(res.body);
    if (deleted['Status'] == 'DeleteBerhasil') {
      SnackBar snackBar = SnackBar(
        duration: Duration(seconds: 1),
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
              'Hapus berhasil',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'SUKSES',
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
          Navigator.pushReplacementNamed(context, '/ListDokter');
        },
      );
      // Navigator.pushReplacementNamed(context, '/ListDokter');
    } else if (deleted['Status'] == 'AdaDiJadwal') {
      SnackBar snackBar = SnackBar(
        duration: Duration(seconds: 2),
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.warning,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: mediaQueryData.size.width * 0.01,
            ),
            Text(
              'Dokter ada di jadwal',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        action: SnackBarAction(
          label: 'GAGAL',
          textColor: Colors.white,
          onPressed: () {
            // Navigator.pushReplacementNamed(context, '/ListLayanan');
            print('Berhasil');
          },
        ),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
      print("ada di jadwal");
    } else {
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
              'Hapus gagal',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'ULANGI',
          textColor: Colors.white,
          onPressed: () {
            // Navigator.pushReplacementNamed(context, '/ListLayanan');
            print('Berhasil');
          },
        ),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
    print(deleted);
    // DeleteGagal
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
                _daftardokter(),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
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
              child: Container(
                padding: EdgeInsets.only(
                  top: mediaQueryData.size.height * 0.01,
                  // left: mediaQueryData.size.height * 0.01,
                  // right: mediaQueryData.size.height * 0.01,
                  // bottom: mediaQueryData.size.height * 0.02,
                ),
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
                              top: mediaQueryData.size.height * 0.2),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                new Icon(
                                  Icons.person,
                                  size: 150,
                                  color: Colors.grey[300],
                                ),
                                Text(
                                  "Dokter masih kosong",
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
                          return new Container(
                            padding: new EdgeInsets.all(3.0),
                            child: Container(
                              // clipBehavior: Clip.antiAliasWithSaveLayer,
                              // elevation: 1.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0.0, 5.0),
                                      blurRadius: 10.0),
                                ],
                              ),
                              // color: Colors.white,
                              child: Material(
                                child: InkWell(
                                  onTap: () {
                                    // Navigator.pushNamed(
                                    //     context, '/DetailDokter');
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                        builder: (context) => new DetailDokter(
                                          vNamaDokter: dataJSON[i]
                                              ["NamaDokter"],
                                          vSpesialis: dataJSON[i]["Spesialis"],
                                          vMoto: dataJSON[i]["Moto"],
                                          vKarir: dataJSON[i]["Karir"],
                                          vJumlahRate: dataJSON[i]
                                              ["JumlahRate"],
                                          vFoto: dataJSON[i]["Foto"],
                                          vRating: dataJSON[i]["Rating"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        // margin: const EdgeInsets.only(right: 15.0),
                                        // width: 120.0,
                                        // height: 100.0,
                                        child: Image(
                                          image: new NetworkImage(
                                              dataJSON[i]["Foto"]),
                                          fit: BoxFit.cover,
                                          height: 100.0,
                                          width: 100.0,
                                        ),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.only(
                                            left: mediaQueryData.size.height *
                                                0.01),
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
                                                        const EdgeInsets.only(
                                                            top: 5.0,
                                                            bottom: 10.0),
                                                    child: new Text(
                                                      dataJSON[i]["NamaDokter"],
                                                      style: new TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        //fontWeight: FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                new Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10.0),
                                                  child: new Text(
                                                    dataJSON[i]["Rating"]
                                                            .substring(0, 3) +
                                                        ' Rating',
                                                    style: new TextStyle(
                                                        fontSize: 12.0,
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            new Container(
                                              child: new Row(
                                                children: <Widget>[
                                                  // new Text(
                                                  //   dataJSON[i]["Karir"],
                                                  //   style: new TextStyle(
                                                  //     fontSize: 12.0,
                                                  //     color: Colors.black54,
                                                  //   ),
                                                  //   maxLines: 1,
                                                  //   overflow:
                                                  //       TextOverflow.ellipsis,
                                                  // ),
                                                  // Container(
                                                  //     height: 10,
                                                  //     child: VerticalDivider(
                                                  //         color: Colors.grey)),
                                                  // new Container(
                                                  //   margin:
                                                  //       const EdgeInsets.only(
                                                  //           left: 5.0),
                                                  new Text(
                                                    dataJSON[i]["Spesialis"],
                                                    style: new TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            new Container(
                                              margin: EdgeInsets.only(
                                                right:
                                                    mediaQueryData.size.width *
                                                        0.1,
                                                top:
                                                    mediaQueryData.size.height *
                                                        0.01,
                                              ),
                                              child: new Text(
                                                dataJSON[i]["Moto"],
                                                style: new TextStyle(
                                                    fontSize: 11.0,
                                                    color: Colors.grey[500]
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

                        return Slidable(
                          controller: slidableController,
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: _container(),
                          actions: <Widget>[
                            IconSlideAction(
                              caption: 'Edit',
                              color: Colors.blue,
                              icon: Icons.edit,
                              onTap: () {
                                Navigator.of(context).push(
                                  new MaterialPageRoute(
                                    builder: (context) => new EditDokter(
                                      eNama: dataJSON[i]["NamaDokter"],
                                      eSpesialis: dataJSON[i]["Spesialis"],
                                      eMoto: dataJSON[i]["Moto"],
                                      eKarir: dataJSON[i]["Karir"],
                                      eId: dataJSON[i]["IdDokter"],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
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
                                  desc: dataJSON[i]["NamaDokter"],
                                  title: "Hapus Dokter? ",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Tidak",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: Colors.green,
                                    ),
                                    DialogButton(
                                      child: Text(
                                        "Hapus",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      onPressed: () async {
                                        hapusdokter(dataJSON[i]["IdDokter"]);
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _daftardokter() {
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
            "List Dokter",
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

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
  // Widget _listkecamatan() {
  //   return GridView.builder(
  //     gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       childAspectRatio: MediaQuery.of(context).size.width /
  //           (MediaQuery.of(context).size.height / 8),
  //     ),
  //     physics: ClampingScrollPhysics(),
  //     shrinkWrap: true,
  //     itemCount: dataJSON == null ? 0 : dataJSON.length,
  //     itemBuilder: (context, index) {
  //       return Container(
  //         padding: EdgeInsets.all(3.0),
  //         child: FlatButton(
  //           color: Color(0xFFee002d),
  //           textColor: Colors.white,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: new BorderRadius.circular(5.0),
  //           ),
  //           child: Align(
  //             alignment: Alignment.center,
  //             child: Text(dataJSON[index]["kecamatan"],
  //                 style: TextStyle(fontSize: 12.0),
  //                 textAlign: TextAlign.center),
  //           ),
  //           onPressed: () {
  //             // Navigator.push(
  //             //   context,
  //             //   MaterialPageRoute(
  //             //     builder: (context) => ListDesa(
  //             //       dNama: dataJSON[index]["kecamatan"],
  //             //       dId: dataJSON[index]["id"],
  //             //     ),
  //             //   ),
  //             // );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget cardKecamatan() {
  //   return Container(
  //     padding: new EdgeInsets.all(5.0),
  //     // width: SizeConfig.safeBlockHorizontal * 100,
  //     // height: SizeConfig.safeBlockVertical * 20,
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //         colors: [
  //           Color(0xFFee002d),
  //           Color(0xFFe3002a),
  //           Color(0xFFd90028),
  //           Color(0xFFcc0025),
  //         ],
  //         stops: [0.1, 0.4, 0.7, 0.9],
  //       ),
  //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //       boxShadow: [
  //         BoxShadow(
  //             color: Colors.black.withOpacity(0.1),
  //             offset: Offset(0.0, 3.0),
  //             blurRadius: 15.0)
  //       ],
  //     ),
  //     child: Row(
  //       children: <Widget>[
  //         Padding(
  //           padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: <Widget>[
  //               Image.asset(
  //                 'assets/images/kecamatan1.png',
  //                 // width: SizeConfig.safeBlockHorizontal * 30,
  //                 // height: SizeConfig.safeBlockVertical * 30,
  //               ),
  //               // SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
  //               new Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   AutoSizeText(
  //                     'Daftar Kecamatan',
  //                     minFontSize: 2,
  //                     maxLines: 2,
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 20.0,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   AutoSizeText(
  //                     'Di KABUPATEN KENDAL',
  //                     minFontSize: 10,
  //                     style: TextStyle(color: Colors.white, fontSize: 14.0),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
