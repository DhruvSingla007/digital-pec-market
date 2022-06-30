import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_major/Screens/homeScreen.dart';
import 'package:user_major/Widgets/item_listTile.dart';
import 'package:user_major/assistantMethods/total_amount.dart';
import '../Models/items.dart';
import '../Widgets/cartItemListTile.dart';
import '../Widgets/cart_item_design.dart';
import '../Widgets/menu_gridTile.dart';
import '../Widgets/progress_bar.dart';
import '../Widgets/seller_listTile.dart';
import '../assistantMethods/assistant_methods.dart';
import '../assistantMethods/cart_Item_counter.dart';
import 'confirmOrderScreen.dart';
import 'splashScreen.dart';

class CartScreen extends StatefulWidget {
  final String sellerUID;

  CartScreen({required this.sellerUID});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;
  num totalAmount = 0;
  num totalEPA = 0;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    totalEPA = 0;
    separateItemQuantityList = separateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Cart",
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              clearCartNow(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (c) => const HomeScreen()),
                  (route) => false);

              Fluttertoast.showToast(msg: "Cart has been cleared.");
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward_outlined),
        onPressed: () {
          int len = separateItemQuantityList!.length;
          if (len == 0) {
            Fluttertoast.showToast(msg: "Please add items in your cart");
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => ConfirmOrderScreen(
                  totalAmount: totalAmount,
                  totalEPA: totalEPA,
                  sellerUID: widget.sellerUID,
                ),
              ),
            );
          }
        },
      ),
      body: ListView(
        children: [
          //display cart items with quantity number
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("items")
                .where("itemUID", whereIn: separateItemIDs())
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final items = snapshot.data!.docs;
                print(items.length);
                int index = 0;
                List<CartItemListTile> cartListTiles = [];
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
                  final int quantity = separateItemQuantityList![index];

                  if (index == 0) {
                    totalAmount = 0;
                    totalEPA = 0;
                    totalAmount += int.parse(price) * quantity;
                    totalEPA += int.parse(epa);
                  } else {
                    totalAmount += int.parse(price) * quantity;
                    totalEPA += int.parse(epa);
                  }

                  index++;

                  Items items = Items(
                      sellerUID: sellerUID,
                      price: price,
                      title: itemTitle,
                      shortInfo: itemInfo,
                      longDescription: itemDescription,
                      itemID: itemUID,
                      epa: epa,
                      menuID: menuUID,
                      publishedDate: publishedDate,
                      status: status,
                      thumbnailUrl: thumbnail);

                  final cartItem = CartItemListTile(
                    itemQuantity: quantity,
                    itemEpa: epa,
                    itemPrice: price,
                    itemName: itemTitle,
                    onTapFunction: () {
                      print(totalAmount);
                      print(totalEPA);
                    },
                    imageUrl: thumbnail,
                  );

                  cartListTiles.add(cartItem);
                }

                return Column(
                  children: cartListTiles,
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
