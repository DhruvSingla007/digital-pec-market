import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_major/Screens/cartScreen.dart';
import '../Models/menus.dart';
import '../Widgets/drawer.dart';
import '../Widgets/menu_gridTile.dart';
import '../Widgets/seller_listTile.dart';
import '../global.dart';
import 'itemScreen.dart';

class MenuScreen extends StatefulWidget {
  final String sellerUID;
  final String sellerContact;

  MenuScreen({required this.sellerUID, required this.sellerContact});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  _callNumber() async{
    String number = widget.sellerContact; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _callNumber,
        child: const Icon(Icons.call),
      ),
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text("Menus"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => CartScreen(
                    sellerUID: widget.sellerUID,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      drawer: const HomePageDrawer(),
      body: SafeArea(
        child: ListView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("sellers")
                  .doc(widget.sellerUID)
                  .collection("menus")
                  .orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final menus = snapshot.data!.docs;
                  List<MenuGridTile> menuListTiles = [];
                  for (var menu in menus) {
                    final String menuTitle = menu.get("menuTitle");
                    final String menuInfo = menu.get("menuInfo");
                    final String thumbnail = menu.get("thumbnail");
                    final Timestamp publishedDate = menu.get("publishedDate");
                    final String sellerUID = menu.get("sellerUID");
                    final String status = menu.get("status");
                    final String menuUID = menu.get("menuUID");
                    final menuListTile = MenuGridTile(
                      context: context,
                      imageUrl: thumbnail,
                      menuTitle: menuTitle,
                      menuInfo: menuInfo,
                      onTapFunction: () {
                        Menus menu = Menus(
                          menuTitle: menuTitle,
                          menuID: menuUID,
                          menuInfo: menuInfo,
                          publishedDate: publishedDate,
                          sellerUID: sellerUID,
                          status: status,
                          thumbnailUrl: thumbnail,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => ItemScreen(
                              menu: menu,
                            ),
                          ),
                        );
                      },
                    );

                    menuListTiles.add(menuListTile);
                  }
                  return Column(
                    children: menuListTiles,
                  );
                }
                return const Center(
                  child: Center(
                    child: Text(
                      'Unexpected Error Occurred',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
