import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:antrian_dokter/data.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDokter extends StatefulWidget {
  final String eNama, eSpesialis, eMoto, eKarir, eId;

  EditDokter({
    this.eNama,
    this.eSpesialis,
    this.eMoto,
    this.eKarir,
    this.eId,
  });
  @override
  _EditDokterState createState() => _EditDokterState();
}

class _EditDokterState extends State<EditDokter> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List allLayanan = List();
  bool _loading = false;
  bool _inProcess = false;

  TextEditingController eNama = new TextEditingController();
  TextEditingController eSpesialis = new TextEditingController();
  TextEditingController eMoto = new TextEditingController();
  TextEditingController eKarir = new TextEditingController();
  TextEditingController eId = new TextEditingController();
  File _selectedFile;

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
    eNama = new TextEditingController(text: "${widget.eNama}");
    eSpesialis = new TextEditingController(text: "${widget.eSpesialis}");
    eMoto = new TextEditingController(text: "${widget.eMoto}");
    eKarir = new TextEditingController(text: "${widget.eKarir}");
    eId = new TextEditingController(text: "${widget.eId}");
    super.initState();
    getLayanan();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getImage(ImageSource source) async {
    this.setState(
      () {
        _inProcess = true;
      },
    );
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(source: source);

    if (image != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 500,
        maxHeight: 500,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.black,
          toolbarTitle: "Crop",
          statusBarColor: Colors.black,
          backgroundColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
        ),
      );

      this.setState(
        () {
          _selectedFile = cropped;
          _inProcess = false;
        },
      );
    } else {
      this.setState(
        () {
          _inProcess = false;
        },
      );
    }
  }

  void _editDokterTanpaGambar() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    setState(
      () {
        _loading = true;
      },
    );
    Future.delayed(
      Duration(seconds: 3),
      () async {
        String theUrl = getMyUrl.url + 'Dokter/EditData';
        var res = await http.post(
          Uri.encodeFull(theUrl),
          headers: {"Accept": "application/json"},
          body: {
            "id": eId.text,
            "nama": eNama.text,
            "spesialis": eSpesialis.text,
            "moto": eMoto.text,
            "karir": eKarir.text,
            "petugas": pref.getString('IdUser').toString(),
            // "petugas": '1',
          },
        );
        var editDokter = json.decode(res.body);
        print(editDokter);
        if (editDokter['Status'] == 'EditBerhasil') {
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
                  'Dokter berhasil diedit',
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
        } else if (editDokter['Status'] == 'EditGagal') {
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
                  'Dokter Gagal diedit',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                print('Berhasil');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          print(editDokter);
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
                  'Dokter gagal diedit',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                print('Berhasil');
              },
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          print(editDokter);
        }
      },
    );
  }

  Future editDokterGambar(File _selectedFile) async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(
      () {
        _loading = true;
      },
    );

    var stream =
        // ignore: deprecated_member_use
        new http.ByteStream(DelegatingStream.typed(_selectedFile.openRead()));
    var length = await _selectedFile.length();
    // var uri =
    //     Uri.parse("http://192.168.98.118/klinikapp/webservice/Dokter/EditData");

    var uri =
        Uri.parse("http://klinik.antrianpasien.id/webservice/Dokter/EditData");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("foto", stream, length,
        filename: basename(_selectedFile.path));
    request.fields['id'] = eId.text;
    request.fields['nama'] = eNama.text;
    // request.fields['layanan'] = cLayanan;
    request.fields['spesialis'] = eSpesialis.text;
    request.fields['moto'] = eMoto.text;
    request.fields['karir'] = eKarir.text;
    request.fields['petugas'] = pref.getString('IdUser').toString();
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      setState(
        () {
          _loading = false;
        },
      );

      print("Image Uploaded");
      print(response);
      SnackBar snackBar = SnackBar(
        duration: Duration(seconds: 5),
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
              'Dokter berhasil diedit',
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
              '/ListDokter', ModalRoute.withName('/ListDokter'));
        },
      );
    } else {
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
              'Dokter gagal diedit',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            print('Berhasil');
          },
        ),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
      print("Upload Failed");
    }
    response.stream.transform(utf8.decoder).listen(
      (value) {
        print(value);
      },
    );
  }

  // ignore: missing_return
  Future<String> getLayanan() async {
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
                    _inputNamaDokter(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _inputSpesialis(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _inputMoto(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _inputKarir(),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        getImageWidget(),
                        Column(
                          children: [
                            _cameraButton(),
                            new Padding(
                              padding: new EdgeInsets.only(
                                  top: mediaQueryData.size.height * 0.01),
                            ),
                            _galeryButton(),
                          ],
                        ),
                        (_inProcess)
                            ? Container(
                                color: Colors.white,
                                height:
                                    MediaQuery.of(context).size.height * 0.95,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Center()
                      ],
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
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

  Widget getImageWidget() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile,
        width: mediaQueryData.size.width * 0.3,
        // height: 250,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/images/placeholder.jpg",
        width: mediaQueryData.size.width * 0.3,
        // height: mediaQueryData.size.height * 0.2,
        // fit: BoxFit.cover,
      );
    }
  }

  Widget _inputuser() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
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
            "Edit Dokter",
            style: new TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _inputNamaDokter() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: eNama,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Nama',
          hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputSpesialis() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: eSpesialis,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Spesialis',
          hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(
            Icons.stars,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputMoto() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: eMoto,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Moto',
          hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(
            Icons.textsms,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputKarir() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: eKarir,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: 'Karir',
          hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(
            Icons.recent_actors,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Container(
      width: mediaQueryData.size.width,
      height: mediaQueryData.size.height * 0.07,
      child: RaisedButton(
        onPressed: () async {
          // upload(_selectedFile);
          if (eNama.text == null || eNama.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Nama Wajib di Isi',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange[700],
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('ULANGI snackbar');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
          } else if (eSpesialis.text == null || eSpesialis.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Alamat belum di Isi',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange[700],
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('ULANGI snackbar');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
          } else if (eMoto.text == null || eMoto.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Status belum di Isi',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange[700],
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('ULANGI snackbar');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
          } else if (eKarir.text == null || eKarir.text == '') {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Hp belum di Isi',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange[700],
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('ULANGI snackbar');
                },
              ),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
          } else {
            if (_selectedFile == null) {
              _editDokterTanpaGambar();
            } else {
              editDokterGambar(_selectedFile);
            }
          }
        },
        child: Text(
          'TAMBAH',
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

  Widget _cameraButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Container(
      width: mediaQueryData.size.height * 0.15,
      height: mediaQueryData.size.height * 0.05,
      child: RaisedButton(
        onPressed: () {
          getImage(ImageSource.camera);
        },
        child: Row(
          children: [
            Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
            new Padding(
              padding:
                  new EdgeInsets.only(left: mediaQueryData.size.height * 0.01),
            ),
            Text(
              'Kamera',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        color: Colors.orange[700],
        elevation: 0,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _galeryButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Container(
      width: mediaQueryData.size.height * 0.15,
      height: mediaQueryData.size.height * 0.05,
      child: RaisedButton(
        onPressed: () {
          getImage(ImageSource.gallery);
        },
        child: Row(
          children: [
            Icon(
              Icons.photo,
              color: Colors.white,
            ),
            new Padding(
              padding:
                  new EdgeInsets.only(left: mediaQueryData.size.height * 0.01),
            ),
            Text(
              'Galeri',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        color: Colors.red,
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
