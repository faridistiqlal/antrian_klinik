import 'package:antrian_dokter/edit/edit_jadwal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';
import 'package:antrian_dokter/data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListJadwal extends StatefulWidget {
  @override
  _ListJadwalState createState() => _ListJadwalState();
}

class _ListJadwalState extends State<ListJadwal> {
  List dataJSON;
  List dokterlist = List();
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

  // ignore: missing_return
  Future<String> ambildatajadwal() async {
    String theUrl = getMyUrl.url + 'Dokter/GetAllJadwal';
    var res = await http.get(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
    );
    var alljadwal = json.decode(res.body);
    print(alljadwal);
    this.setState(
      () {
        dataJSON = json.decode(res.body);
      },
    );
  }

  void hapusjadwal(jadwallist) async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    String theUrl = getMyUrl.url + 'Dokter/DeleteJadwal';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "id": jadwallist,
      },
    );
    var deleted = json.decode(res.body);
    print(deleted);
    // Navigator.pushReplacementNamed(context, '/ListJadwal');
    if (deleted['Status'] == 'DeleteBerhasil') {
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
          Navigator.pushReplacementNamed(context, '/ListJadwal');
        },
      );
      // Navigator.pushReplacementNamed(context, '/ListDokter');
    }
  }

  @override
  void initState() {
    super.initState();
    ambildatajadwal();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   backgroundColor: Colors.orange,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   title: Text(
      //     "Dokter",
      //     style: new TextStyle(color: Colors.white),
      //   ),
      //   centerTitle: true,
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
                        if (dataJSON[i]["id_jadwal"] == 'NotFound') {
                          return Container(
                            padding: new EdgeInsets.only(
                                top: mediaQueryData.size.height * 0.2),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  new Icon(
                                    Icons.access_time,
                                    size: 150,
                                    color: Colors.grey[300],
                                  ),
                                  Text(
                                    "Tidak ada Jadwal",
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
                                    onTap: () {},
                                    child: new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // new ClipRRect(
                                        //   borderRadius: BorderRadius.circular(9.0),
                                        //   // margin: const EdgeInsets.only(right: 15.0),
                                        //   // width: 120.0,
                                        //   // height: 100.0,
                                        //   child: Image(
                                        //     image:
                                        //         new NetworkImage(dataJSON[i]["Foto"]),
                                        //     fit: BoxFit.cover,
                                        //     height: 100.0,
                                        //     width: 100.0,
                                        //   ),
                                        // ),
                                        Material(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Color(0xFF44AEA5)
                                              .withOpacity(0.2),
                                          child: IconButton(
                                            padding: EdgeInsets.all(15.0),
                                            icon: Icon(Icons.schedule),
                                            color: Color(0xFF44AEA5),
                                            iconSize: 70.0,
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
                                                              top: 5.0,
                                                              bottom: 10.0),
                                                      child: new Text(
                                                        dataJSON[i]
                                                            ["nama_dokter"],
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
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: new Text(
                                                      "Pelayanan : " +
                                                          dataJSON[i][
                                                              "waktu_pelayanan"] +
                                                          " Jam",
                                                      style: new TextStyle(
                                                          fontSize: 12.0,
                                                          color:
                                                              Colors.grey[600]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              new Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: new Text(
                                                  "Kuota " +
                                                      dataJSON[i]
                                                          ["quota_jadwal"],
                                                  style: new TextStyle(
                                                    fontSize: 14.0,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              new Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: new Row(
                                                  children: <Widget>[
                                                    new Text(
                                                      "Tanggal : " +
                                                          dataJSON[i]
                                                              ["tgl_aktif"],
                                                      style: new TextStyle(
                                                        color: Colors.grey[500],
                                                        fontSize: 11.0,
                                                      ),
                                                    ),
                                                    new Text(
                                                      " -",
                                                      style: new TextStyle(
                                                        color: Colors.grey[500],
                                                        fontSize: 11.0,
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   height: 10,
                                                    //   child: VerticalDivider(
                                                    //       color: Colors.grey),
                                                    // ),
                                                    new Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5.0),
                                                      child: new Text(
                                                        dataJSON[i]
                                                            ["tgl_nonaktif"],
                                                        style: new TextStyle(
                                                          fontSize: 11.0,
                                                          color:
                                                              Colors.grey[500],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              new Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5.0, bottom: 5.0),
                                                child: new Row(
                                                  children: <Widget>[
                                                    new Text(
                                                      "Jam : " +
                                                          dataJSON[i][
                                                              "jammulai_jadwal"],
                                                      style: new TextStyle(
                                                        color: Colors.grey[500],
                                                        fontSize: 11.0,
                                                      ),
                                                    ),
                                                    new Text(
                                                      " -",
                                                      style: new TextStyle(
                                                        color: Colors.grey[500],
                                                        fontSize: 11.0,
                                                      ),
                                                    ),
                                                    // Container(
                                                    //     height: 10,
                                                    //     child: VerticalDivider(
                                                    //         color:
                                                    //             Colors.grey)),
                                                    new Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5.0),
                                                      child: new Text(
                                                        dataJSON[i][
                                                            "jamselesai_jadwal"],
                                                        style: new TextStyle(
                                                          fontSize: 11.0,
                                                          color:
                                                              Colors.grey[500],
                                                        ),
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
                                      builder: (context) => new EditJadwal(
                                        eId: dataJSON[i]["id_dokter"],
                                        eNamaDokter: dataJSON[i]["nama_dokter"],
                                        eIdJadwal: dataJSON[i]["id_jadwal"],
                                        eIdLayanan: dataJSON[i]["id_layanan"],
                                        eWaktu: dataJSON[i]["waktu_pelayanan"],
                                        eJamMulai: dataJSON[i]
                                            ["jammulai_jadwal"],
                                        eJamSelesai: dataJSON[i]
                                            ["jamselesai_jadwal"],
                                        eTglAktif: dataJSON[i]["tgl_aktif"],
                                        eTglNonAktif: dataJSON[i]
                                            ["tgl_nonaktif"],
                                        eStatusTgl: dataJSON[i]["status_tgl"],
                                        eQuotaJadwal: dataJSON[i]
                                            ["quota_jadwal"],
                                        eStatusJadwal: dataJSON[i]
                                            ["status_jadwal"],
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
                                    desc: dataJSON[i]["nama_dokter"],
                                    title: "Hapus Dokter? ",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Tidak",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        color: Colors.green,
                                      ),
                                      DialogButton(
                                        child: Text(
                                          "Hapus",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        onPressed: () {
                                          hapusjadwal(dataJSON[i]["id_jadwal"]);
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
                    }),
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
            "List Jadwal",
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
