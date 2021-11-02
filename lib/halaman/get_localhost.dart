import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:antrian_dokter/data.dart';

class GetLocalhost extends StatefulWidget {
  @override
  _GetLocalhostState createState() => _GetLocalhostState();
}

class _GetLocalhostState extends State<GetLocalhost> {
  getMethod() async {
    //String theUrl = 'http://192.168.43.118/teslocalhost/getData.php';
    String theUrl = getMyUrl.url + 'teslocalhost/getData.php';
    var res = await http
        .get(Uri.encodeFull(theUrl), headers: {"Accept": "application/json"});
    var responsBody = json.decode(res.body);
    print(responsBody);
    return responsBody;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Localhost"),
      ),
      body: FutureBuilder(
        future: getMethod(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error fetch Data"),
            );
          }
          return ListView.builder(
            itemCount: snap.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("head : ${snap[index]['heading']}"),
                subtitle: Text("body ${snap[index]['body']}"),
              );
            },
          );
        },
      ),
    );
  }
}
