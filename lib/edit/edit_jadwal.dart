import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:antrian_dokter/data.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

class EditJadwal extends StatefulWidget {
  final String eId,
      eNamaDokter,
      eIdJadwal,
      eIdLayanan,
      eWaktu,
      eJamMulai,
      eJamSelesai,
      eTglAktif,
      eTglNonAktif,
      eStatusTgl,
      eQuotaJadwal,
      eStatusJadwal;

  EditJadwal({
    this.eId,
    this.eNamaDokter,
    this.eIdJadwal,
    this.eIdLayanan,
    this.eJamMulai,
    this.eWaktu,
    this.eJamSelesai,
    this.eTglAktif,
    this.eTglNonAktif,
    this.eStatusTgl,
    this.eQuotaJadwal,
    this.eStatusJadwal,
  });

  @override
  _EditJadwalState createState() => _EditJadwalState();
}

class _EditJadwalState extends State<EditJadwal> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List allDokter = List();
  List allLayanan = List();
  final formatTime = DateFormat("HH:mm");
  final format = DateFormat("yyyy-MM-dd");
  // ignore: unused_field
  bool _obscureText = true;
  // ignore: unused_field
  bool _loading = false;
  // ignore: unused_field
  bool _sudahlogin = false;
  List _statusTgl = [
    {
      "id": '1',
      "status": 'Aktif',
    },
    {
      "id": '0',
      "status": 'Tidak Aktif',
    },
  ];

  List _status = [
    {
      "id": '1',
      "status": 'Aktif',
    },
    {
      "id": '0',
      "status": 'Tidak Aktif',
    },
  ];

  TextEditingController eId = new TextEditingController();
  TextEditingController eNamaDokter = new TextEditingController();
  TextEditingController eIdJadwal = new TextEditingController();
  TextEditingController eIdLayanan = new TextEditingController();
  TextEditingController eWaktu = new TextEditingController();
  TextEditingController eJamMulai = new TextEditingController();
  TextEditingController eJamSelesai = new TextEditingController();
  TextEditingController eTglAktif = new TextEditingController();
  TextEditingController eTglNonAktif = new TextEditingController();
  TextEditingController eStatusTgl = new TextEditingController();
  TextEditingController eQuotaJadwal = new TextEditingController();
  TextEditingController eStatusJadwal = new TextEditingController();

  String cIdDokter;
  String cLayanan;
  // TextEditingController cWaktu = new TextEditingController();
  // TextEditingController cJamMulai = new TextEditingController();
  // TextEditingController cJamSelesai = new TextEditingController();
  // TextEditingController cTglAktif = new TextEditingController();
  // TextEditingController cTglNonAktif = new TextEditingController();
  String cStatusTgl;
  // TextEditingController cQuota = new TextEditingController();
  String cStatus;

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
    alertAlignment: Alignment.center,
  );

  @override
  void initState() {
    super.initState();
    eId = new TextEditingController(text: "${widget.eId}");
    eNamaDokter = new TextEditingController(text: "${widget.eNamaDokter}");
    eIdJadwal = new TextEditingController(text: "${widget.eIdJadwal}");
    eIdLayanan = new TextEditingController(text: "${widget.eIdLayanan}");
    eWaktu = new TextEditingController(text: "${widget.eWaktu}");
    eJamMulai = new TextEditingController(text: "${widget.eJamMulai}");
    eJamSelesai = new TextEditingController(text: "${widget.eJamSelesai}");
    eTglAktif = new TextEditingController(text: "${widget.eTglAktif}");
    eTglNonAktif = new TextEditingController(text: "${widget.eTglNonAktif}");
    eStatusTgl = new TextEditingController(text: "${widget.eStatusTgl}");
    eQuotaJadwal = new TextEditingController(text: "${widget.eQuotaJadwal}");
    eStatusJadwal = new TextEditingController(text: "${widget.eStatusJadwal}");
    getDokter();
    getLayanan();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getDokter() async {
    String theUrl = getMyUrl.url + 'Dokter/GetAllData';
    var res = await http.get(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
    );
    var iddokter = json.decode(res.body);
    print(iddokter);
    this.setState(
      () {
        allDokter = iddokter;
      },
    );
  }

  Future getLayanan() async {
    String theUrl = getMyUrl.url + 'Layanan/GetData';
    var res = await http.get(
      Uri.encodeFull(theUrl),
      headers: {"Accept": "application/json"},
    );
    var layanan = json.decode(res.body);
    print(layanan);
    this.setState(
      () {
        allLayanan = layanan;
      },
    );
  }

  void _editJadwal() async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    setState(
      () {
        _loading = true;
      },
    );
    Future.delayed(
      Duration(seconds: 2),
      () async {
        if (cIdDokter == null || cIdDokter == '') {
          cIdDokter = "${widget.eId}";
        } else {
          cIdDokter = cIdDokter;
        }

        if (cLayanan == null || cLayanan == '') {
          cLayanan = "${widget.eIdLayanan}";
        } else {
          cLayanan = cLayanan;
        }

        if (cStatusTgl == null || cStatusTgl == '') {
          cStatusTgl = "${widget.eStatusTgl}";
        } else {
          cStatusTgl = cStatusTgl;
        }

        if (cStatus == null || cStatus == '') {
          cStatus = "${widget.eStatusJadwal}";
        } else {
          cStatus = cStatus;
        }
        String theUrl = getMyUrl.url + 'Dokter/EditJadwal';
        var res = await http.post(
          Uri.encodeFull(theUrl),
          headers: {"Accept": "application/json"},
          body: {
            "id": eIdJadwal.text,
            "iddokter": cIdDokter,
            "layanan": cLayanan,
            "jammulai": eJamMulai.text,
            "jamselesai": eJamSelesai.text,
            "waktu": eWaktu.text,
            "tglaktif": eTglAktif.text,
            "tglnonaktif": eTglNonAktif.text,
            "statustgl": cStatusTgl,
            "quota": eQuotaJadwal.text,
            "status": cStatus,
          },
        );
        var editJadwal = json.decode(res.body);
        print(editJadwal);
        if (editJadwal['Status'] == 'EditBerhasil') {
          setState(
            () {
              _loading = false;
            },
          );
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
                  'Jadwal berhasil diedit',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                print('Berhasil');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          await Future.delayed(
            Duration(seconds: 2),
            () {
              Navigator.of(this.context).pushNamedAndRemoveUntil(
                  '/HalTabAdmin', ModalRoute.withName('/HalTabAdmin'));
            },
          );
          print(editJadwal);
        } else if (editJadwal['Status'] == 'EditGagal') {
          setState(
            () {
              _loading = false;
            },
          );
          SnackBar snackBar = SnackBar(
            duration: Duration(seconds: 5),
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
                  'Jadwal gagal diedit',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {
                print('Berhasil');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          print(editJadwal);
        } else {
          setState(
            () {
              _loading = false;
            },
          );
          SnackBar snackBar = SnackBar(
            duration: Duration(seconds: 5),
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
                  'Jadwal gagal diedit',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {
                print('Berhasil');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          print(editJadwal);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      // resizeToAvoidBottomInset: false,
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
            Container(
              width: mediaQueryData.size.height,
              height: mediaQueryData.size.height * 0.4,
              decoration: BoxDecoration(
                color: Color(0xFF44AEA5),
              ),
              child: Column(
                children: <Widget>[
                  _inputuser(),
                ],
              ),
            ),
            // _logo(),
            Container(
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: mediaQueryData.size.height * 0.03,
                  right: mediaQueryData.size.height * 0.03,
                  // bottom: mediaQueryData.size.height * 0.02,
                  // top: mediaQueryData.size.height * 0.001,
                ),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // _text(),
                    // new Padding(
                    //   padding: new EdgeInsets.only(
                    //       top: mediaQueryData.size.height * 0.03),
                    // ),
                    _inputDokter(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _inputLayanan(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _inputWaktu(),

                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),

                    Row(
                      children: [
                        Flexible(
                          child: _inputjamMulai(),
                        ),
                        SizedBox(
                          width: mediaQueryData.size.width * 0.01,
                        ),
                        Flexible(
                          child: _inputJamSelesai(),
                        )
                      ],
                    ),
                    // _inputjamMulai(),
                    // new Padding(
                    //   padding: new EdgeInsets.only(
                    //       top: mediaQueryData.size.height * 0.03),
                    // ),
                    // _inputKelamin(),

                    // _inputJamSelesai(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _inputStatusTgl(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),

                    Row(
                      children: [
                        Flexible(
                          child: _inputTglAktif(),
                        ),
                        SizedBox(
                          width: mediaQueryData.size.width * 0.01,
                        ),
                        Flexible(
                          child: _inputTglTidakAktif(),
                        )
                      ],
                    ),

                    // _inputTglAktif(),
                    // new Padding(
                    //   padding: new EdgeInsets.only(
                    //       top: mediaQueryData.size.height * 0.03),
                    // ),
                    // _inputTglTidakAktif(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),

                    _inputQuota(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _inputStatus(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.05),
                    ),
                    _loginButton(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.08),
                    ),
                    //_daftar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputuser() {
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
            "Edit Jadwal",
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

  Widget _inputDokter() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Container(
      padding: EdgeInsets.only(
          top: mediaQueryData.size.height * 0.005,
          left: mediaQueryData.size.height * 0.01,
          right: mediaQueryData.size.height * 0.02),
      height: mediaQueryData.size.height * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton(
        underline: SizedBox(),
        hint: Row(
          children: <Widget>[
            SizedBox(
              width: mediaQueryData.size.width * 0.01,
            ),
            Icon(
              Icons.person,
              color: Colors.grey,
            ),
            Text(
              "    Pilih Dokter",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        isExpanded: true,
        items: allDokter.map(
          (item) {
            return new DropdownMenuItem(
              child: new Text(item['NamaDokter']),
              value: item['IdDokter'].toString(),
            );
          },
        ).toList(),
        onChanged: (newVal) {
          setState(
            () {
              cIdDokter = newVal;
            },
          );
        },
        value: cIdDokter,
      ),
    );
  }

  Widget _inputLayanan() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Container(
      padding: EdgeInsets.only(
          top: mediaQueryData.size.height * 0.005,
          left: mediaQueryData.size.height * 0.01,
          right: mediaQueryData.size.height * 0.02),
      height: mediaQueryData.size.height * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton(
        underline: SizedBox(),
        hint: Row(
          children: <Widget>[
            SizedBox(
              width: mediaQueryData.size.width * 0.01,
            ),
            Icon(
              Icons.airline_seat_flat_angled,
              color: Colors.grey,
            ),
            Text(
              "    Pilih Layanan",
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        isExpanded: true,
        items: allLayanan.map(
          (item) {
            return new DropdownMenuItem(
              child: new Text(item['Nama']),
              value: item['Id'].toString(),
            );
          },
        ).toList(),
        onChanged: (newVal) {
          setState(
            () {
              cLayanan = newVal;
            },
          );
        },
        value: cLayanan,
      ),
    );
  }

  Widget _inputWaktu() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: eWaktu,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Berapa Jam praktik',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.timelapse,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputjamMulai() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: DateTimeField(
        controller: eJamMulai,
        format: formatTime,
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child),
          );
          return DateTimeField.convert(time);
        },
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Jam Mulai',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.access_time,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputJamSelesai() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: DateTimeField(
        controller: eJamSelesai,
        format: formatTime,
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child),
          );
          return DateTimeField.convert(time);
        },
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Jam Selesai',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.access_time,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputTglAktif() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: DateTimeField(
        controller: eTglAktif,
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100),
          );
        },
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Tgl Aktif',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.date_range,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputTglTidakAktif() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: DateTimeField(
        controller: eTglNonAktif,
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100),
          );
        },
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Tgl Non Aktif',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.date_range,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputStatusTgl() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(
          top: mediaQueryData.size.height * 0.005,
          left: mediaQueryData.size.height * 0.01,
          right: mediaQueryData.size.height * 0.02),
      height: mediaQueryData.size.height * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        underline: SizedBox(),
        hint: Row(
          children: <Widget>[
            SizedBox(
              width: mediaQueryData.size.width * 0.01,
            ),
            Icon(
              Icons.check_circle,
              color: Colors.grey,
            ),
            Text(
              "    Pilih Status Tanggal",
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        isExpanded: true,
        items: _statusTgl.map(
          (item) {
            return new DropdownMenuItem<String>(
              value: item['id'],
              child: new Text(item['status']),
            );
          },
        ).toList(),
        onChanged: (newVal) {
          setState(
            () {
              cStatusTgl = newVal;
            },
          );
        },
        value: cStatusTgl,
      ),
    );
  }

  Widget _inputQuota() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: eQuotaJadwal,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Quota',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          prefixIcon: Icon(
            Icons.pie_chart_outline_rounded,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputStatus() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(
          top: mediaQueryData.size.height * 0.005,
          left: mediaQueryData.size.height * 0.01,
          right: mediaQueryData.size.height * 0.02),
      height: mediaQueryData.size.height * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        underline: SizedBox(),
        hint: Row(
          children: <Widget>[
            SizedBox(
              width: mediaQueryData.size.width * 0.01,
            ),
            Icon(
              Icons.verified_user,
              color: Colors.grey,
            ),
            Text(
              "    Pilih Status",
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        isExpanded: true,
        items: _status.map(
          (item) {
            return new DropdownMenuItem<String>(
              value: item['id'].toString(),
              child: new Text(item['status']),
            );
          },
        ).toList(),
        onChanged: (newVal) {
          setState(
            () {
              cStatus = newVal;
            },
          );
        },
        value: cStatus,
      ),
    );
  }

  Widget _loginButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: mediaQueryData.size.height * 0.07,
      child: RaisedButton(
        onPressed: () async {
          _editJadwal();
          // if (cNama.text == null || cNama.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Nama Wajib di Isi',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     backgroundColor: Colors.orange[700],
          //     action: SnackBarAction(
          //       label: 'ULANGI',
          //       textColor: Colors.white,
          //       onPressed: () {
          //         print('ULANGI snackbar');
          //       },
          //     ),
          //   );
          //   scaffoldKey.currentState.showSnackBar(snackBar);
          // } else if (cAlamat.text == null || cAlamat.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Alamat belum di Isi',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     backgroundColor: Colors.orange[700],
          //     action: SnackBarAction(
          //       label: 'ULANGI',
          //       textColor: Colors.white,
          //       onPressed: () {
          //         print('ULANGI snackbar');
          //       },
          //     ),
          //   );
          //   scaffoldKey.currentState.showSnackBar(snackBar);
          // } else if (cKelamin == null || cKelamin == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Status belum di Isi',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     backgroundColor: Colors.orange[700],
          //     action: SnackBarAction(
          //       label: 'ULANGI',
          //       textColor: Colors.white,
          //       onPressed: () {
          //         print('ULANGI snackbar');
          //       },
          //     ),
          //   );
          //   scaffoldKey.currentState.showSnackBar(snackBar);
          // } else if (cHp.text == null || cHp.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Hp belum di Isi',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     backgroundColor: Colors.orange[700],
          //     action: SnackBarAction(
          //       label: 'ULANGI',
          //       textColor: Colors.white,
          //       onPressed: () {
          //         print('ULANGI snackbar');
          //       },
          //     ),
          //   );
          //   scaffoldKey.currentState.showSnackBar(snackBar);
          // } else if (cEmail.text == null || cEmail.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Hp belum di Isi',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     backgroundColor: Colors.orange[700],
          //     action: SnackBarAction(
          //       label: 'ULANGI',
          //       textColor: Colors.white,
          //       onPressed: () {
          //         print('ULANGI snackbar');
          //       },
          //     ),
          //   );
          //   scaffoldKey.currentState.showSnackBar(snackBar);
          // } else if (cUsername.text == null || cUsername.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'Username belum di Isi',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     backgroundColor: Colors.orange[700],
          //     action: SnackBarAction(
          //       label: 'ULANGI',
          //       textColor: Colors.white,
          //       onPressed: () {
          //         print('ULANGI snackbar');
          //       },
          //     ),
          //   );
          //   scaffoldKey.currentState.showSnackBar(snackBar);
          // } else if (cPassword.text == null || cPassword.text == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'password belum di Isi',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     backgroundColor: Colors.orange[700],
          //     action: SnackBarAction(
          //       label: 'ULANGI',
          //       textColor: Colors.white,
          //       onPressed: () {
          //         print('ULANGI snackbar');
          //       },
          //     ),
          //   );
          //   scaffoldKey.currentState.showSnackBar(snackBar);
          // } else if (cStatus == null || cStatus == '') {
          //   SnackBar snackBar = SnackBar(
          //     content: Text(
          //       'status belum di Isi',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     backgroundColor: Colors.orange[700],
          //     action: SnackBarAction(
          //       label: 'ULANGI',
          //       textColor: Colors.white,
          //       onPressed: () {
          //         print('ULANGI snackbar');
          //       },
          //     ),
          //   );
          //   scaffoldKey.currentState.showSnackBar(snackBar);
          // } else {
          //   _addUser();
          // }
        },
        child: Text(
          'SIMPAN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Color(0xFF44AEA5),
        elevation: 0,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Widget _daftar() {
  //   return Container(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Text("Belum punya akun?"),
  //         GestureDetector(
  //           onTap: () {
  //             Navigator.pushNamed(context, '/HalPilihAKun');
  //           },
  //           child: Text(
  //             "  Daftar",
  //             style: TextStyle(
  //               fontSize: 14.0,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.blueAccent[100],
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
