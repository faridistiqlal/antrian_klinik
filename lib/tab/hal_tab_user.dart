// //ANCHOR package tabbar berita
// import 'package:flutter/material.dart';
// // import 'package:dokar_aplikasi/berita/hal_search.dart';
// import './hal_profil_user.dart' as user;
// import 'hal_janji_aktif.dart' as dokter;
// import './hal_kartu_user.dart' as kartu;
// import './hal_janji_user.dart' as janji;
// import './hal_home_user.dart' as home;

// class TabUser extends StatefulWidget {
//   @override
//   _TabUserState createState() => _TabUserState();
// }

// class _TabUserState extends State<TabUser> with SingleTickerProviderStateMixin {
//   String value;
//   TabController controller;
//   @override
//   void initState() {
//     controller = new TabController(vsync: this, length: 5);
//     super.initState();
//   }

//   Icon cusIcon = Icon(Icons.search);
//   // Widget custSearchBar = Text("DOKAR");

//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         automaticallyImplyLeading: false,
//         // leading: IconButton(
//         //   icon: Icon(Icons.dehaze, color: Colors.white),
//         //   onPressed: () {
//         //     Navigator.pushNamed(context, '/ListKecamatan');
//         //   },
//         // ),
//         backgroundColor: Colors.green,
//         centerTitle: true,
//         // actions: <Widget>[
//         //   IconButton(
//         //     onPressed: () {
//         //       setState(
//         //         () {
//         //           if (this.cusIcon.icon == Icons.search) {
//         //             this.cusIcon = Icon(Icons.cancel);
//         //             this.custSearchBar = TextField(
//         //               autofocus: false,
//         //               onSubmitted: (text) {
//         //                 value = text;
//         //                 Navigator.of(context).push(MaterialPageRoute(
//         //                   builder: (context) => Search(value: value),
//         //                 ));
//         //               },
//         //               textInputAction: TextInputAction.go,
//         //               decoration: InputDecoration(
//         //                 filled: true,
//         //                 fillColor: Colors.white,
//         //                 border: InputBorder.none,
//         //                 hintText: "Cari...",
//         //                 hintStyle:
//         //                     TextStyle(fontSize: 16.0, color: Colors.grey[600]),
//         //                 contentPadding: const EdgeInsets.only(
//         //                     left: 14.0, bottom: 8.0, top: 8.0),
//         //                 focusedBorder: OutlineInputBorder(
//         //                   borderSide: BorderSide(color: Colors.white),
//         //                   borderRadius: BorderRadius.circular(25.7),
//         //                 ),
//         //                 enabledBorder: UnderlineInputBorder(
//         //                   borderSide: BorderSide(color: Colors.white),
//         //                   borderRadius: BorderRadius.circular(25.7),
//         //                 ),
//         //               ),
//         //               style: TextStyle(
//         //                 color: Colors.black,
//         //                 fontSize: 16.0,
//         //               ),
//         //             );
//         //           } else {
//         //             this.cusIcon = Icon(Icons.search);
//         //             this.custSearchBar = Text("DOKAR");
//         //           }
//         //         },
//         //       );
//         //     },
//         //     icon: cusIcon,
//         //   ),
//         // ],
//         //title: custSearchBar,
//         title: Text(
//           "ANTRIAN",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: new TabBarView(
//         controller: controller,
//         children: <Widget>[
//           new home.Home(),
//           new janji.Janji(),
//           new kartu.Kartu(),
//           new dokter.Dokter(),
//           new user.Profil(),
//         ],
//       ),
//       bottomNavigationBar: new Material(
//         color: Colors.green,
//         child: new TabBar(
//           labelColor: Colors.white,
//           indicatorColor: Colors.white,
//           controller: controller,
//           tabs: <Widget>[
//             new Tab(
//               icon: new Icon(
//                 Icons.home,
//                 color: Colors.white,
//               ),
//               text: 'Home',
//             ),
//             new Tab(
//               icon: new Icon(
//                 Icons.event_available,
//                 color: Colors.white,
//               ),
//               text: 'Janji',
//             ),
//             new Tab(
//               icon: new Icon(
//                 Icons.credit_card,
//                 color: Colors.white,
//               ),
//               text: 'Kartu',
//             ),
//             new Tab(
//               icon: new Icon(
//                 Icons.location_city,
//                 color: Colors.white,
//               ),
//               text: 'Dokter',
//             ),
//             new Tab(
//               icon: new Icon(
//                 Icons.account_circle,
//                 color: Colors.white,
//               ),
//               text: 'Profil',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
