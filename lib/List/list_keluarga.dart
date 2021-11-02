import 'package:antrian_dokter/edit/edit_admin_blm_menikah.dart';
import 'package:antrian_dokter/edit/edit_admin_menikah.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';
import 'package:antrian_dokter/data.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Listkeluarga extends StatefulWidget {
  @override
  _ListkeluargaState createState() => _ListkeluargaState();
}

class _ListkeluargaState extends State<Listkeluarga> {
  List dataJSON;
  List keluargalist = List();
  String statusPasien = '';
  final SlidableController slidableController = SlidableController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Future ambildatakeluarga() async {
    String theUrl = getMyUrl.url + 'Pasien/GetAllData';
    var res = await http.get(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
    );
    var alluser = json.decode(res.body);
    print(alluser);
    this.setState(
      () {
        dataJSON = json.decode(res.body);
      },
    );
  }

  void _editpasienadmin(status, norm) async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // String theUrl = getMyUrl.url + 'Pasien/GetKK';
    // var res = await http.post(
    //   Uri.encodeFull(theUrl),
    //   headers: {"Accept": "application/json"},
    //   body: {
    //     "NoRm": pref.getString("Username"),
    //   },
    // );
    // print(res);
    // if (this.mounted) {
    //   setState(
    //     () {
    //       statusPasien = status;
    //     },
    //   );
    // }
    if (status == 'Ibu' || status == 'Ayah') {
      Navigator.of(this.context).push(
        new MaterialPageRoute(
          builder: (context) => new EditAdminMenikah(
            noRM: norm,
          ),
        ),
      );
      print("ayah");
    } else {
      Navigator.of(this.context).push(
        new MaterialPageRoute(
          builder: (context) => new EditAdminBlmMenikah(
            noRM: norm,
          ),
        ),
      );
      print("anak");
    }
  }

  void aktifpasien(norm) async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    String theUrl = getMyUrl.url + 'Pasien/Aktifkan';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "norm": norm,
      },
    );
    var deleted = json.decode(res.body);
    print(deleted);
    if (deleted['Status'] == 'Sukses') {
      SnackBar snackBar = SnackBar(
        duration: Duration(seconds: 2),
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.lock_open,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: mediaQueryData.size.width * 0.01,
            ),
            Text(
              'Pasien Aktif',
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
          Navigator.pushReplacementNamed(context, '/Listkeluarga');
        },
      );
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
              'Pasien aktif',
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
        Duration(seconds: 2),
        () {
          Navigator.pushReplacementNamed(context, '/Listkeluarga');
        },
      );
    }
    // Navigator.pushReplacementNamed(context, '/HalBumdesList');
  }

  void nonaktifkan(norm) async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    String theUrl = getMyUrl.url + 'Pasien/DeleteData';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "norm": norm,
      },
    );
    var deleted = json.decode(res.body);
    print(deleted);
    if (deleted['Status'] == 'Sukses') {
      SnackBar snackBar = SnackBar(
        duration: Duration(seconds: 2),
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.lock_outline,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: mediaQueryData.size.width * 0.01,
            ),
            Text(
              'Pasien Nonaktif',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.grey[600],
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
          Navigator.pushReplacementNamed(context, '/Listkeluarga');
        },
      );
    } else {
      SnackBar snackBar = SnackBar(
        duration: Duration(seconds: 2),
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.lock_open,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: mediaQueryData.size.width * 0.01,
            ),
            Text(
              'Pasien aktif',
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
          Navigator.pushReplacementNamed(context, '/Listkeluarga');
        },
      );
    }
    // Navigator.pushReplacementNamed(context, '/Listkeluarga');
  }

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

  @override
  void initState() {
    super.initState();
    ambildatakeluarga();
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
                      if (dataJSON[i]["NoKK"] == 'NotFound') {
                        return Container(
                          padding: new EdgeInsets.only(
                              top: mediaQueryData.size.height * 0.2),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                new Icon(
                                  Icons.people,
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
                        Widget _container() {
                          if (dataJSON[i]["Aktif"] == '1') {
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
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => DetailBerita(
                                      //         dBaca: databerita[i]["dibaca"],
                                      //         dDesa: databerita[i]["desa"],
                                      //         dKecamatan: databerita[i]["kecamatan"],
                                      //         dGambar: databerita[i]["gambar"],
                                      //         dKategori: databerita[i]["kategori"],
                                      //         dJudul: databerita[i]["judul"],
                                      //         dAdmin: databerita[i]["admin"],
                                      //         dTanggal: databerita[i]["tanggal"],
                                      //         dHtml: databerita[i]["isi"],
                                      //         dUrl: databerita[i]["url"],
                                      //         dId: databerita[i]["id"],
                                      //         dIdDesa: databerita[i]["id_desa"],
                                      //         dVideo: databerita[i]["video"]),
                                      //   ),
                                      // );
                                      //print(databerita);
                                    },
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
                                            icon: Icon(Icons.person),
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
                                                              top: 5.0,
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
                                                  new Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: new Text(
                                                      dataJSON[i]["NoRm"],
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
                                                  dataJSON[i]["NoKK"],
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
                                                      dataJSON[i]["Alamat"],
                                                      style: new TextStyle(
                                                        color: Colors.grey[500],
                                                        fontSize: 11.0,
                                                      ),
                                                    ),
                                                    Container(
                                                        height: 10,
                                                        child: VerticalDivider(
                                                            color:
                                                                Colors.grey)),
                                                    new Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5.0),
                                                      child: new Text(
                                                        dataJSON[i]["TTL"],
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
                                  color: Colors.grey[200],
                                  child: InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => DetailBerita(
                                      //         dBaca: databerita[i]["dibaca"],
                                      //         dDesa: databerita[i]["desa"],
                                      //         dKecamatan: databerita[i]["kecamatan"],
                                      //         dGambar: databerita[i]["gambar"],
                                      //         dKategori: databerita[i]["kategori"],
                                      //         dJudul: databerita[i]["judul"],
                                      //         dAdmin: databerita[i]["admin"],
                                      //         dTanggal: databerita[i]["tanggal"],
                                      //         dHtml: databerita[i]["isi"],
                                      //         dUrl: databerita[i]["url"],
                                      //         dId: databerita[i]["id"],
                                      //         dIdDesa: databerita[i]["id_desa"],
                                      //         dVideo: databerita[i]["video"]),
                                      //   ),
                                      // );
                                      //print(databerita);
                                    },
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
                                          color: Colors.grey[300],
                                          child: IconButton(
                                            padding: EdgeInsets.all(15.0),
                                            icon: Icon(Icons.person),
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
                                                              top: 5.0,
                                                              bottom: 10.0),
                                                      child: new Text(
                                                        dataJSON[i]["Nama"],
                                                        style: new TextStyle(
                                                          fontSize: 15.0,
                                                          color: Colors.grey,
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
                                                      dataJSON[i]["NoRm"],
                                                      style: new TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              new Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: new Text(
                                                  dataJSON[i]["NoKK"],
                                                  style: new TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.grey,
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
                                                      dataJSON[i]["Alamat"],
                                                      style: new TextStyle(
                                                        color: Colors.grey[500],
                                                        fontSize: 11.0,
                                                      ),
                                                    ),
                                                    Container(
                                                        height: 10,
                                                        child: VerticalDivider(
                                                            color:
                                                                Colors.grey)),
                                                    new Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5.0),
                                                      child: new Text(
                                                        dataJSON[i]["TTL"],
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
                        }

                        if (dataJSON[i]["Aktif"] == '1') {
                          return Slidable(
                            controller: slidableController,
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: _container(),
                            actions: <Widget>[
                              IconSlideAction(
                                caption: "Edit",
                                color: Colors.blue,
                                icon: Icons.edit,
                                onTap: () {
                                  _editpasienadmin(dataJSON[i]["Status"],
                                      dataJSON[i]["NoRm"]);
                                  // setState(() {
                                  //   statusPasien = dataJSON[i]["Status"];
                                  // });
                                  // if (dataJSON[i]["Status"] == 'Ibu' ||
                                  //     dataJSON[i]["Status"] == 'Ayah') {
                                  // Navigator.of(this.context).push(
                                  //   new MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         new EditAdminMenikah(
                                  //       noRM: dataJSON[i]["NoRm"],
                                  //     ),
                                  //   ),
                                  // );
                                  // print("ayah");
                                  // } else {
                                  // Navigator.of(this.context).push(
                                  //   new MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         new EditAdminBlmMenikah(
                                  //       noRM: dataJSON[i]["NoRm"],
                                  //     ),
                                  //   ),
                                  // );
                                  // print("anak");
                                  // }
                                },
                              ),
                            ],
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Non aktif?',
                                color: Colors.grey[600],
                                icon: Icons.lock,
                                onTap: () {
                                  Alert(
                                    style: alertStyle,
                                    context: context,
                                    type: AlertType.warning,
                                    desc: dataJSON[i]["Nama"],
                                    title: "Nonaktifkan pasien? ",
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
                                          "Nonaktif",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        onPressed: () {
                                          nonaktifkan(dataJSON[i]["NoRm"]);
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
                        } else {
                          return Slidable(
                            controller: slidableController,
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: _container(),
                            actions: <Widget>[
                              IconSlideAction(
                                caption: "Edit",
                                color: Colors.blue,
                                icon: Icons.edit,
                                onTap: () {
                                  _editpasienadmin(dataJSON[i]["Status"],
                                      dataJSON[i]["NoRm"]);
                                },
                              ),
                            ],
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Aktifkan?',
                                color: Colors.green,
                                icon: Icons.lock_open,
                                onTap: () {
                                  Alert(
                                    style: alertStyle,
                                    context: context,
                                    type: AlertType.warning,
                                    desc: dataJSON[i]["Nama"],
                                    title: "Hapus User? ",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Tidak",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        color: Colors.red,
                                      ),
                                      DialogButton(
                                        child: Text(
                                          "AKtifkan",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        onPressed: () {
                                          aktifpasien(dataJSON[i]["NoRm"]);
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
            "List Keluarga",
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
