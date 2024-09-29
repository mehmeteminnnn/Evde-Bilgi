import 'package:evde_bilgi/aile_talep_formu/aile_talep_formu.dart';
import 'package:evde_bilgi/giris_sayfalari/aile_girisi.dart';
import 'package:evde_bilgi/giris_sayfalari/ogretmen_giris.dart';
import 'package:evde_bilgi/ilan_sayfalari/ilan_ver.dart';
import 'package:evde_bilgi/iletisim.dart';
import 'package:evde_bilgi/kayit_sayfalari/aile_kayit.dart';
import 'package:evde_bilgi/models/ilan_model.dart';
import 'package:evde_bilgi/uye_olma.dart';
import 'package:flutter/material.dart';

class EvdeBilgiAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EvdeBilgiAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
    );
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class EvdeBilgiDrawer extends StatefulWidget {
  const EvdeBilgiDrawer({super.key});

  @override
  State<EvdeBilgiDrawer> createState() => _EvdeBilgiDrawerState();
}

class _EvdeBilgiDrawerState extends State<EvdeBilgiDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              'assets/logov3.png',
              fit: BoxFit
                  .cover, // Tüm alanı doldurması için cover kullanabilirsin.
              width: double.infinity, // Genişliği tam olarak doldurması için.
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Ana Sayfa'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('İş İlanları'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UyeOlma()));
              // Handle the action
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text('İlan Ver'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AileTalepFormu()));
            },
          ),

          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Aile Girişi'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AileGirisEkrani()));
            },
            // Handle the action
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Uzman Girişi'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OgretmenGirisEkrani()));
              // Handle the action
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_phone),
            title: const Text('İletişim'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactPage()));
              // Handle the action
            },
          ),
          const Spacer(), // This will push the following ListTile to the bottom
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Üye Ol'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UyeOlma()));
              // Handle the action
            },
          ),
        ],
      ),
    );
  }
}
