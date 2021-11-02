import 'package:flutter/material.dart';

import 'package:antrian_dokter/halaman/hal_admin_janji.dart' as janji;
import 'package:antrian_dokter/dashbord/hal_dashbord_admin.dart'
    as dashbordadmin;

class HalTabAdmin extends StatefulWidget {
  @override
  _HalTabAdminState createState() => _HalTabAdminState();
}

class _HalTabAdminState extends State<HalTabAdmin> {
  int _currentIndex = 0;
  final tabs = [
    janji.DashbordAdminJanji(),
    dashbordadmin.DashbordAdmin(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.blueAccent[100],
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/Janji');
      //   },
      //   child: new Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
      // appBar: AppBar(title: Text("flutter")),
      body: tabs[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        //backgroundColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.event_note,
              // color: Color(0xFF44AEA5),
            ),
            icon: Icon(Icons.event_note),
            title: Text(
              "Janji",
              // style: TextStyle(color: Color(0xFF44AEA5)),
            ),
            // backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.storage,
              // color: Color(0xFF44AEA5),
            ),
            icon: Icon(
              Icons.storage,
              // color: Color(0xFF44AEA5),
            ),
            title: Text(
              "Data",
              // style: TextStyle(color: Color(0xFF44AEA5)),
            ),
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
