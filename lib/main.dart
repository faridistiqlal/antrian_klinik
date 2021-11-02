//ANCHOR package navigator
import 'package:antrian_dokter/List/list_dokter.dart';
import 'package:antrian_dokter/List/list_jadwal.dart';
import 'package:antrian_dokter/List/list_keluarga.dart';
import 'package:antrian_dokter/List/list_layanan.dart';
import 'package:antrian_dokter/List/list_user.dart';
import 'package:antrian_dokter/admin/hal_janji_hariini.dart';
import 'package:antrian_dokter/admin/hal_pilih_add_user.dart';
import 'package:antrian_dokter/admin/hal_post_belum_berkeluarga_admin.dart';
import 'package:antrian_dokter/admin/hal_post_dokter.dart';
import 'package:antrian_dokter/admin/hal_post_jadwal.dart';
import 'package:antrian_dokter/admin/hal_post_keluarga_admin.dart';
import 'package:antrian_dokter/admin/hal_post_layanan.dart';
import 'package:antrian_dokter/admin/hal_post_user.dart';
import 'package:antrian_dokter/admin/hal_profil_admin.dart';
import 'package:antrian_dokter/dashbord/hal_dashbord.dart';
import 'package:antrian_dokter/dashbord/hal_dashbord_admin.dart';
import 'package:antrian_dokter/edit/edit_admin_blm_menikah.dart';
import 'package:antrian_dokter/edit/edit_admin_menikah.dart';
import 'package:antrian_dokter/edit/edit_dokter.dart';
import 'package:antrian_dokter/edit/edit_jadwal.dart';
import 'package:antrian_dokter/edit/edit_layanan.dart';
import 'package:antrian_dokter/edit/edit_pasien_blm_menikah.dart';
import 'package:antrian_dokter/edit/edit_pasien_menikah.dart';
import 'package:antrian_dokter/edit/edit_user.dart';
import 'package:antrian_dokter/edit/edit_user_admin.dart';
import 'package:antrian_dokter/halaman/detail_dokter.dart';
import 'package:antrian_dokter/halaman/get_localhost.dart';
import 'package:antrian_dokter/halaman/hal_admin_janji_all.dart';
import 'package:antrian_dokter/halaman/hal_belum_berkeluarga.dart';
import 'package:antrian_dokter/halaman/hal_card_daftar.dart';
import 'package:antrian_dokter/halaman/hal_cek.dart';
import 'package:antrian_dokter/halaman/hal_data_keluarga.dart';
import 'package:antrian_dokter/halaman/hal_gambar.dart';
import 'package:antrian_dokter/halaman/hal_jadwal_dokter.dart';
import 'package:antrian_dokter/halaman/hal_keluarga.dart';
import 'package:antrian_dokter/halaman/hal_layanan.dart';
import 'package:antrian_dokter/halaman/hal_login.dart';
import 'package:antrian_dokter/halaman/hal_pilih_akun.dart';
import 'package:antrian_dokter/halaman/hal_rating_pasien.dart';
import 'package:antrian_dokter/halaman/hal_riwayat_pasien.dart';
import 'package:antrian_dokter/halaman/hal_tab_admin.dart';
import 'package:antrian_dokter/splash/splashscreen.dart';
import 'package:antrian_dokter/tab/hal_dokter_user.dart';
import 'package:antrian_dokter/tab/hal_janji_aktif.dart';
import 'package:antrian_dokter/tab/hal_janji_user.dart';

import 'package:antrian_dokter/tambah/rubah_menikah.dart';
import 'package:antrian_dokter/tambah/tambah_anak.dart';
import 'package:antrian_dokter/tambah/tambah_ortu.dart';
import 'package:antrian_dokter/tambah/tambah_pasangan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light),
  );
//ANCHOR routes halaman
  runApp(
    MaterialApp(
      theme: ThemeData(
        // splashColor: Colors.transparent,
        // highlightColor: Colors.transparent,
        primaryColor: Colors.blueAccent[100],
      ),
      debugShowCheckedModeBanner: false,
      title: 'Splash Screen',
      routes: <String, WidgetBuilder>{
        '/DaftarAdmin': (BuildContext context) => new DaftarAdmin(),
        '/Janji': (BuildContext context) => new Janji(),
        '/HalPilihAKun': (BuildContext context) => new HalPilihAKun(),
        '/Halkeluarga': (BuildContext context) => new Halkeluarga(),
        '/HalBelumkeluarga': (BuildContext context) => new HalBelumkeluarga(),
        '/CardDaftar': (BuildContext context) => new CardDaftar(),
        '/GetLocalhost': (BuildContext context) => new GetLocalhost(),
        '/JanjiAKtif': (BuildContext context) => new JanjiAKtif(),
        '/Dashbord': (BuildContext context) => new Dashbord(),
        '/DashbordAdmin': (BuildContext context) => new DashbordAdmin(),
        '/InputLayanan': (BuildContext context) => new InputLayanan(),
        '/InputDokter': (BuildContext context) => new InputDokter(),
        '/TambahOrtu': (BuildContext context) => new TambahOrtu(),
        '/TambahAnak': (BuildContext context) => new TambahAnak(),
        '/TambahPasangan': (BuildContext context) => new TambahPasangan(),
        '/HalCek': (BuildContext context) => new HalCek(),
        '/ListDokter': (BuildContext context) => new ListDokter(),
        '/ListLayanan': (BuildContext context) => new ListLayanan(),
        '/ListUser': (BuildContext context) => new ListUser(),
        '/ListJadwal': (BuildContext context) => new ListJadwal(),
        '/InputUser': (BuildContext context) => new InputUser(),
        '/InputJadwal': (BuildContext context) => new InputJadwal(),
        '/Listkeluarga': (BuildContext context) => new Listkeluarga(),
        '/HalProfilAdmin': (BuildContext context) => new HalProfilAdmin(),
        '/EditLayanan': (BuildContext context) => new EditLayanan(),
        '/EditUser': (BuildContext context) => new EditUser(),
        '/EditDokter': (BuildContext context) => new EditDokter(),
        '/HalPostKeluargaAdmin': (BuildContext context) =>
            new HalPostKeluargaAdmin(),
        '/HalPostBelumKeluargaAdmin': (BuildContext context) =>
            new HalPostBelumKeluargaAdmin(),
        '/HalPilihUserAdmin': (BuildContext context) => new HalPilihUserAdmin(),
        '/EditJadwal': (BuildContext context) => new EditJadwal(),
        '/HalRiwayatPasien': (BuildContext context) => new HalRiwayatPasien(),
        '/HalLayanan': (BuildContext context) => new HalLayanan(),
        '/HalDataKeluarga': (BuildContext context) => new HalDataKeluarga(),
        '/HalJadwalDokter': (BuildContext context) => new HalJadwalDokter(),
        '/RubahMenikah': (BuildContext context) => new RubahMenikah(),
        '/EditpasienMenikah': (BuildContext context) => new EditpasienMenikah(),
        '/EditpasienBlmMenikah': (BuildContext context) =>
            new EditpasienBlmMenikah(),
        '/ListDokterPasien': (BuildContext context) => new ListDokterPasien(),
        '/HalTabAdmin': (BuildContext context) => new HalTabAdmin(),
        '/HalJanjiHariIni': (BuildContext context) => new HalJanjiHariIni(),
        '/HalJanjiHariIniAll': (BuildContext context) =>
            new HalJanjiHariIniAll(),
        '/DetailDokter': (BuildContext context) => new DetailDokter(),
        '/HalRating': (BuildContext context) => new HalRating(),
        '/EditAdminMenikah': (BuildContext context) => new EditAdminMenikah(),
        '/EditAdminBlmMenikah': (BuildContext context) =>
            new EditAdminBlmMenikah(),
        '/EditUserAdmin': (BuildContext context) => new EditUserAdmin(),
        '/DetailGaleri': (BuildContext context) => new DetailGaleri(),
      },
      home: SplashScreenPage(),
    ),
  );
}
