import 'package:flutter/material.dart';
import 'package:antrian_dokter/tab/hal_kartu_user.dart' as kartu;
import 'package:antrian_dokter/tab/hal_profil_user.dart' as profil;
import 'package:antrian_dokter/tab/hal_dokter_user.dart' as dokter;
import 'package:antrian_dokter/dashbord/hal_dashbord.dart' as dashbord;

class HalCek extends StatefulWidget {
  @override
  _HalCekState createState() => _HalCekState();
}

class _HalCekState extends State<HalCek> {
  int _currentIndex = 0;
  final tabs = [
    dashbord.Dashbord(),
    kartu.Kartu(),
    Center(child: Text("2")),
    dokter.ListDokterPasien(),
    profil.Profil(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent[100],
        onPressed: () {
          Navigator.pushNamed(context, '/Janji');
        },
        child: new Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      // appBar: AppBar(title: Text("flutter")),
      body: tabs[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        //backgroundColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: "Kartu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Janji",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: "Dokter",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Akun",
          ),
        ],
        onTap: (index) {
          if (index != 2) {
            setState(
              () {
                _currentIndex = index;
              },
            );
          }
        },
      ),
    );
  }
}
