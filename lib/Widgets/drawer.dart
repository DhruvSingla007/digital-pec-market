import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_major/Screens/homeScreen.dart';
import 'package:user_major/Screens/myOrdersScreen.dart';
import 'package:user_major/Screens/orderHistoryScreen.dart';
import 'package:user_major/Screens/pendingOrderScreen.dart';
import '../Screens/splashScreen.dart';
import '../global.dart';

class HomePageDrawer extends StatefulWidget {
  const HomePageDrawer({Key? key}) : super(key: key);

  @override
  _HomePageDrawerState createState() => _HomePageDrawerState();
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  String userName = "";
  String userEmail = "";

  Future<void> _getInfo() async {
    SharedPreferences? sharedPreferences =
        await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences.getString("userName") ?? "name";
      userEmail = sharedPreferences.getString("userEmail") ?? "email";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInfo();
  }

  Widget _buildDrawerListTile(
      {required String title,
      required IconData icon,
      required Function function}) {
    return ListTile(
      onTap: () {
        function();
      },
      title: Text(title),
      leading: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 30.0,
                color: Colors.blueGrey,
              ),
            ),
            accountEmail: Text(userEmail),
            accountName: Text(userName),
          ),
          _buildDrawerListTile(
            title: "Home",
            icon: Icons.home,
            function: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (c) => const HomeScreen()),
                  (route) => false);
            },
          ),

          const Divider(),
          _buildDrawerListTile(
            title: 'Pending Orders',
            icon: Icons.new_releases,
            function: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => const PendingOrdersScreen()));
            },
          ),

          const Divider(),
          _buildDrawerListTile(
            title: 'Active Orders',
            icon: Icons.reorder,
            function: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => MyOrdersScreen()));
            },
          ),
          const Divider(),
          _buildDrawerListTile(
            title: 'Order History',
            icon: Icons.access_time,
            function: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => const OrderHistoryScreen()));
            },
          ),
          const Divider(),
          _buildDrawerListTile(
            title: 'Log Out',
            icon: Icons.logout,
            function: () async {
              await FirebaseAuth.instance.signOut();
              await sharedPreferences!.clear().then((value) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => const SplashScreen()), (route) => false);
              });

            },
          ),

          const Divider(),
          _buildDrawerListTile(
            title: 'Exit App',
            icon: Icons.power_settings_new,
            function: () {
              exit(0);
            },
          ),
        ],
      ),
    );
  }
}
