import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';
import 'package:antrian_dokter/data.dart';

class HalRating extends StatefulWidget {
  final String idDokter, nama, foto;

  HalRating({
    this.idDokter,
    this.nama,
    this.foto,
  });

  @override
  _HalRatingState createState() => _HalRatingState();
}

class _HalRatingState extends State<HalRating> {
  TextEditingController cidDokter = new TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String norm = "";
  double _rating;
  double _initialRating = 2.0;
  bool _loading = false;
  @override
  void initState() {
    cidDokter = new TextEditingController(text: "${widget.idDokter}");
    _cekUser();
    _rating = _initialRating;
    super.initState();
  }

  void ratingdokter() async {
    setState(
      () {
        _loading = true;
      },
    );
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    String theUrl = getMyUrl.url + 'Dokter/Rate';
    var res = await http.post(
      Uri.encodeFull(theUrl),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "NoRM": norm,
        "IdDokter": "${widget.idDokter}",
        "Rating": _rating.toInt().toString(),
      },
    );
    var rating = json.decode(res.body);
    Future.delayed(
      Duration(seconds: 2),
      () async {
        if (rating['Status'] == 'RatingSukses') {
          setState(
            () {
              _loading = false;
            },
          );
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
                  ' Rating berhasil',
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
            Duration(seconds: 1),
            () {
              Navigator.pushReplacementNamed(context, '/HalCek');
            },
          );
        }
        print(rating);
        print(norm);
        print("${widget.idDokter}");
        print(_rating.toInt());
      },
    );
  }

  Future _cekUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(
      () {
        norm = pref.getString("Username");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: Colors.blue[400],
        opacity: 0.5,
        progressIndicator: SpinKitWave(
          color: Colors.white,
          size: 50,
        ),
        child: Stack(
          children: <Widget>[
            _logo(),
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: mediaQueryData.size.height * 0.3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[50],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _foto(),
                            _namadokter(),
                            _ratingbuilder(),
                            _ratingbutton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );

    // return Scaffold(
    //   body: Container(
    //     padding: EdgeInsets.all(mediaQueryData.size.height * 0.04),
    //     child: Column(
    //       children: [
    //         RatingBar.builder(
    //           initialRating: _initialRating,
    //           minRating: 1,
    //           direction: Axis.horizontal,
    //           // allowHalfRating: true,
    //           itemCount: 5,
    //           itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
    //           itemBuilder: (context, _) => Icon(
    //             Icons.star,
    //             color: Colors.amber,
    //           ),
    //           onRatingUpdate: (rating) {
    //             setState(() {
    //               _rating = rating;
    //             });
    //             print(rating);
    //           },
    //         ),
    //         Text("${widget.idDokter}"),
    //         Text(norm),
    //         _ratingbutton(),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _foto() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.25,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.02,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9.0),
        child: Image.network(
          '${widget.foto}',
          width: mediaQueryData.size.height * 0.2,
          height: mediaQueryData.size.height * 0.2,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _namadokter() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Padding(
      padding: EdgeInsets.only(
        // top: mediaQueryData.size.height * 0.42,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Text(
        "${widget.nama}",
        style: new TextStyle(
            fontSize: 28.0,
            color: Colors.grey[800],
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _ratingbuilder() {
    return RatingBar.builder(
      initialRating: _initialRating,
      minRating: 1,
      direction: Axis.horizontal,
      // allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
        });
        print(rating);
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

  Widget _ratingbutton() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.1,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Container(
        width: mediaQueryData.size.width * 0.7,
        height: mediaQueryData.size.height * 0.07,
        child: RaisedButton(
          onPressed: () async {
            ratingdokter();
            // Navigator.pushNamed(context, '/Halkeluarga');
          },
          child: Text(
            'RATING',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          color: Colors.blueAccent[100],
          elevation: 0,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
