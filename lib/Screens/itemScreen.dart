import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_major/Screens/itemDetailScreen.dart';
import 'package:user_major/Widgets/drawer.dart';
import 'package:user_major/Widgets/item_listTile.dart';
import '../Models/items.dart';
import '../Models/menus.dart';
import '../Widgets/menu_gridTile.dart';
import '../global.dart';
import 'cartScreen.dart';

class ItemScreen extends StatefulWidget {
  final Menus menu;

  ItemScreen({required this.menu});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(widget.menu.menuTitle.toString()),
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
                    sellerUID: widget.menu.sellerUID.toString(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      drawer: const HomePageDrawer(),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(widget.menu.sellerUID)
                .collection("menus")
                .doc(widget.menu.menuID)
                .collection("items")
                .where("status", isEqualTo: "available")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              print(snapshot.hasData);
              if (snapshot.hasData) {
                final items = snapshot.data!.docs;
                List<ItemListTile> itemListTiles = [];
                for (var item in items) {
                  final String itemTitle = item.get("itemTitle");
                  final String itemInfo = item.get("shortInfo");
                  final String itemDescription = item.get("longDescription");
                  final String thumbnail = item.get("thumbnail");
                  final Timestamp publishedDate = item.get("publishedDate");
                  final String sellerUID = item.get("sellerUID");
                  final String status = item.get("status");
                  final String itemUID = item.get("itemUID");
                  final String menuUID = item.get("menuUID");
                  final String epa = item.get("epa");
                  final String price = item.get("price");
                  final itemListTile = ItemListTile(
                    imageUrl: thumbnail,
                    itemName: itemTitle,
                    itemPrice: price,
                    itemEpa: epa,
                    onTapFunction: () {
                      Items item = Items(
                        thumbnailUrl: thumbnail,
                        status: status,
                        sellerUID: sellerUID,
                        publishedDate: publishedDate,
                        menuID: menuUID,
                        epa: epa,
                        itemID: itemUID,
                        longDescription: itemDescription,
                        shortInfo: itemInfo,
                        title: itemTitle,
                        price: price,
                      );
                      // Menus menu = Menus(
                      //   menuTitle: menuTitle,
                      //   menuID: menuUID,
                      //   menuInfo: menuInfo,
                      //   publishedDate: publishedDate,
                      //   sellerUID: sellerUID,
                      //   status: status,
                      //   thumbnailUrl: thumbnail,
                      //
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => ItemDetailsScreen(
                            item: item,
                          ),
                        ),
                      );
                    },
                  );

                  itemListTiles.add(itemListTile);
                }
                return Column(
                  children: itemListTiles,
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
    );
  }
}
