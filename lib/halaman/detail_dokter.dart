import 'package:flutter/material.dart';

class DetailDokter extends StatefulWidget {
  final String vNamaDokter,
      vSpesialis,
      vMoto,
      vKarir,
      vJumlahRate,
      vFoto,
      vRating;

  DetailDokter({
    this.vNamaDokter,
    this.vSpesialis,
    this.vMoto,
    this.vKarir,
    this.vJumlahRate,
    this.vFoto,
    this.vRating,
  });

  @override
  _DetailDokterState createState() => _DetailDokterState();
}

class _DetailDokterState extends State<DetailDokter> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _logo(),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[50],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _foto(),
                  _rating(),
                ],
              ),
              // _foto(),
              _namadokter(),
              _karir(),
              _spesialis(),
              Divider(),
              _moto(),
            ],
          )
        ],
      ),
    );
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
          '${widget.vFoto}',
          width: mediaQueryData.size.height * 0.15,
          height: mediaQueryData.size.height * 0.15,
          fit: BoxFit.fill,
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

  Widget _namadokter() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.42,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Text(
        "${widget.vNamaDokter}",
        style: new TextStyle(
            fontSize: 28.0,
            color: Colors.grey[800],
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _spesialis() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Padding(
        padding: EdgeInsets.only(
          top: mediaQueryData.size.height * 0.47,
          left: mediaQueryData.size.height * 0.02,
          right: mediaQueryData.size.height * 0.02,
          bottom: mediaQueryData.size.height * 0.01,
        ),
        child: Text(
          "Spesialis : " + "${widget.vSpesialis}",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
            // fontWeight: FontWeight.bold,
          ),
        ));
  }

  Widget _karir() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Padding(
        padding: EdgeInsets.only(
          top: mediaQueryData.size.height * 0.51,
          left: mediaQueryData.size.height * 0.02,
          right: mediaQueryData.size.height * 0.02,
          bottom: mediaQueryData.size.height * 0.01,
        ),
        child: Text(
          "${widget.vKarir}",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
            // fontWeight: FontWeight.bold,
          ),
        ));
  }

  Widget _moto() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Padding(
        padding: EdgeInsets.only(
          top: mediaQueryData.size.height * 0.59,
          left: mediaQueryData.size.height * 0.02,
          right: mediaQueryData.size.height * 0.02,
          bottom: mediaQueryData.size.height * 0.01,
        ),
        child: Text(
          "${widget.vMoto}",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
            // fontWeight: FontWeight.bold,
          ),
        ));
  }

  Widget _rating() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.3,
        left: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
        bottom: mediaQueryData.size.height * 0.02,
      ),
      child: Container(
        child: Chip(
          padding: EdgeInsets.all(2),
          backgroundColor: Colors.orange,
          avatar: Icon(
            Icons.star,
            color: Colors.white,
            size: 15,
          ),
          label: Text(
            "${widget.vRating}".substring(0, 3),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
