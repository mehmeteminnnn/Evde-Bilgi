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
            icon: Icon(Icons.menu),
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

  Size get preferredSize => Size.fromHeight(kToolbarHeight);
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
            child: Image.asset('assets/logov3.png'),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Ana Sayfa'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('İş İlanları'),
            onTap: () {
              // Handle the action
            },
          ),
          ListTile(
            leading: Icon(Icons.add_box),
            title: Text('İlan Ver'),
            onTap: () {
              // Handle the action
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Öğretmen Bul'),
            onTap: () {
              // Handle the action
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Aile Girişi'),
            onTap: () {
              // Handle the action
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Öğretmen Girişi'),
            onTap: () {
              // Handle the action
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_phone),
            title: Text('İletişim'),
            onTap: () {
              // Handle the action
            },
          ),
          Spacer(), // This will push the following ListTile to the bottom
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Üye Ol'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UyeOlma()));
              // Handle the action
            },
          ),
        ],
      ),
    );
  }
}