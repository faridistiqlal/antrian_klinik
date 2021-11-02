import 'package:antrian_dokter/edit/edit_layanan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';
import 'package:antrian_dokter/data.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ListLayanan extends StatefulWidget {
  @override
  _ListLayananState createState() => _ListLayananState();
}

class _ListLayananState extends State<ListLayanan> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List dataJSON;
  bool isLoading = true;
  List layananlist = List();
  final SlidableController slidableController = SlidableController();

  Future ambildatalayanan() async {
    String theUrl = getMyUrl.url + 'Layanan/GetData';
    var res = await http.get(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
    );
    var alllayanan = json.decode(res.body);
    print(alllayanan);
    if (this.mounted) {
      this.setState(
        () {
          dataJSON = json.decode(res.body);
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    ambildatalayanan();
  }

  void hapuslayanan(layananlist) async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    String theUrl = getMyUrl.url + 'Layanan/DeleteData';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "id": layananlist,
      },
    );
    var deleted = json.decode(res.body);
    if (deleted['Status'] == 'DeleteBerhasil') {
      SnackBar snackBar = SnackBar(
        duration: Duration(seconds: 5),
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
        Duration(seconds: 1),
        () {
          Navigator.pushReplacementNamed(context, '/ListLayanan');
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
              'Layanan ada di jadwal',
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
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   actions: [
      //     Container(
      //       width: 60,
      //       height: 40,
      //       color: Colors.lightBlue,
      //       child: CircularProgressIndicator(backgroundColor: Colors.red),
      //     ),
      //   ],
      // ),
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
                //_buildProgressIndicator(),
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
                      if (dataJSON[i]["Id"] == 'NotFound') {
                        return Container(
                          padding: new EdgeInsets.only(
                              top: mediaQueryData.size.height * 0.2),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                new Icon(
                                  Icons.airline_seat_flat_angled,
                                  size: 150,
                                  color: Colors.grey[300],
                                ),
                                Text(
                                  "Tidak ada Layanan",
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
                          // return Card(
                          //   elevation: 1,
                          //   child: InkWell(
                          //     onTap: () {
                          //       // Navigator.pushNamed(context, '/ListDokter');
                          //     },
                          //     child: ListTile(
                          //       leading: Material(
                          //         borderRadius: BorderRadius.circular(15.0),
                          //         color: Color(0xFF44AEA5).withOpacity(0.2),
                          //         child: IconButton(
                          //           padding: EdgeInsets.all(15.0),
                          //           icon: Icon(
                          //             Icons.airline_seat_flat_angled,
                          //           ),
                          //           color: Color(0xFF44AEA5),
                          //           iconSize: 25.0,
                          //           onPressed: () {
                          //             // Navigator.pushNamed(context, '/ListDokter');
                          //           },
                          //         ),
                          //       ),
                          //       //value sementara manual ki seng wingi
                          //       subtitle: new Text(
                          //         "Aktif",
                          //         style: new TextStyle(
                          //             fontSize: 12.0, color: Colors.black54),
                          //       ),
                          //       title: new Text(
                          //         //nama ambil json dong...
                          //         dataJSON[i]["Nama"],
                          //         style: new TextStyle(
                          //             fontSize: 18.0,
                          //             fontWeight: FontWeight.bold,
                          //             color: Colors.black87),
                          //       ),
                          //       trailing: Icon(Icons.arrow_forward_ios,
                          //           size: 14.0, color: Colors.black),
                          //     ),
                          //   ),
                          // );
                          if (dataJSON[i]["Status"] == '1') {
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
                                    onTap: () {},
                                    child: new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Material(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Color(0xFF44AEA5)
                                              .withOpacity(0.2),
                                          child: IconButton(
                                            padding: EdgeInsets.all(15.0),
                                            icon: Icon(
                                                Icons.airline_seat_flat_angled),
                                            color: Color(0xFF44AEA5),
                                            iconSize: 50.0,
                                            onPressed: () {
                                              //Navigator.pushNamed(context, '/ListUser');
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              mediaQueryData.size.width * 0.02,
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
                                                              top: 10.0,
                                                              bottom: 10.0),
                                                      child: new Text(
                                                        dataJSON[i]["Nama"],
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
                                                ],
                                              ),
                                              new Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: new Text(
                                                  "Aktif",
                                                  style: new TextStyle(
                                                    fontSize: 14.0,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                          } else {
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
                                  color: Colors.grey[100],
                                  child: InkWell(
                                    onTap: () {},
                                    child: new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Material(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Colors.grey[300],
                                          child: IconButton(
                                            padding: EdgeInsets.all(15.0),
                                            icon: Icon(
                                                Icons.airline_seat_flat_angled),
                                            color: Colors.grey,
                                            iconSize: 50.0,
                                            onPressed: () {
                                              //Navigator.pushNamed(context, '/ListUser');
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              mediaQueryData.size.width * 0.02,
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
                                                              top: 10.0,
                                                              bottom: 10.0),
                                                      child: new Text(
                                                        dataJSON[i]["Nama"],
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
                                                ],
                                              ),
                                              new Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: new Text(
                                                  "Tidak Aktif",
                                                  style: new TextStyle(
                                                    fontSize: 14.0,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                // Navigator.pushNamed(context, '/EditLayanan');
                                //QUESTIONNNNN :
                                //kan navigate ini ngepush data json ke form edit
                                Navigator.of(context).push(
                                  new MaterialPageRoute(
                                    builder: (context) => new EditLayanan(
                                      eNama: dataJSON[i]["Nama"], //nama oke
                                      eStatus: dataJSON[i]["Status"],
                                      eId: dataJSON[i][
                                          "Id"], // nah, kan status disini "1"/"0". oke?oke
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
                                  context: context,
                                  type: AlertType.error,
                                  title: "Hapus? ",
                                  desc: dataJSON[i]["Nama"],
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
                                      onPressed: () {
                                        hapuslayanan(dataJSON[i]["Id"]);
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
            "List Layanan",
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
