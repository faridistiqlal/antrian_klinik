import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dio/dio.dart';
import 'package:shimmer/shimmer.dart';

class HalJanjiHariIniAll extends StatefulWidget {
  @override
  _HalJanjiHariIniAllState createState() => _HalJanjiHariIniAllState();
}

class _HalJanjiHariIniAllState extends State<HalJanjiHariIniAll> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SlidableController slidableController = SlidableController();
  final dio = new Dio();
  List databerita = new List();
  ScrollController _scrollController = new ScrollController();
  // String nextPage = "http://192.168.43.118/klinikapp/webservice/Appoiment/All";
  String nextPage = "http://klinik.antrianpasien.id/webservice/Appoiment/All";
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
  bool isLoading = false;
  void _getMoreData() async {
    // String theUrl = getMyUrl.url + 'appoiment/all';
    //NOTE if else load more
    if (!isLoading) {
      setState(
        () {
          isLoading = true;
        },
      );

      final response = await dio.get(nextPage);
      List tempList = new List();
      nextPage = response.data['next'];
      for (int i = 0; i < response.data['result'].length; i++) {
        tempList.add(response.data['result'][i]);
      }

      setState(
        () {
          isLoading = false;
          databerita.addAll(tempList);
        },
      );
    }
  }

  @override
  void initState() {
    this._getMoreData();
    super.initState();
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMoreData();
        }
      },
    );
  }

  void snackbarrr() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    setState(() {
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
    });
  }

  //ANCHOR dispose
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      // resizeToAvoidBottomInset: false,
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
            "Semua Janji",
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
      controller: _scrollController,
      itemCount: databerita.length + 1,
      itemBuilder: (BuildContext context, int i) {
        if (i == databerita.length) {
          return shimmerantrian();
        } else {
          if (databerita[i]["noantrian"] == 'NotFound') {
            return Center();
            // return Container(
            //   child: Center(
            //     child: Column(
            //       children: <Widget>[
            //         new Icon(
            //           Icons.calendar_today,
            //           size: 150,
            //           color: Colors.grey[300],
            //         ),
            //         Text(
            //           "Tidak ada Riwayat",
            //           style: new TextStyle(
            //             fontSize: 20.0,
            //             color: Colors.grey[300],
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // );
          } else {
            // MediaQueryData mediaQueryData = MediaQuery.of(context);

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
                      icon: Icon(Icons.done_all),
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
                                    databerita[i]["dokter"],
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
                                  databerita[i]["layanan"],
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
                                  'Tanggal : ' + databerita[i]["tanggal"],
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
                                    databerita[i]["jam"],
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
                              'Daftar : ' + databerita[i]["daftar"],
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
                                    databerita[i]["norm"],
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
                                  'No. ' + databerita[i]["noantrian"],
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
      },
    );
  }

  // Widget _buildProgressIndicator() {
  //   return new Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: new Center(
  //       child: new Opacity(
  //         opacity: isLoading ? 1.0 : 00,
  //         child: new CircularProgressIndicator(),
  //       ),
  //     ),
  //   );
  // }

  Widget shimmerantrian() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return isLoading
        ? Padding(
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
          )
        : Container(
            child: Center(
              child: Text(
                "Tidak ada data lagi",
                style: new TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          );
  }
}
