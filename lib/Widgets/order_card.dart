import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_major/Widgets/cartItemListTile.dart';

import '../Models/items.dart';
import '../Screens/orderDetailsScreen.dart';

class OrderCard extends StatelessWidget {
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final List<String>? separateQuantitiesList;

  OrderCard({
    required this.itemCount,
    required this.data,
    required this.orderID,
    required this.separateQuantitiesList,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => OrderDetailsScreen(
              orderID: orderID,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Order ID : #" + orderID.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Train",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueGrey,
                    Colors.blueGrey.shade300,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.decal,
                ),
              ),
              height: itemCount! * 180,
              child: ListView.builder(
                itemCount: itemCount,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Items model = Items.fromJson(
                      data![index].data()! as Map<String, dynamic>);
                  return placedOrderDesignWidget(
                      model, context, separateQuantitiesList![index]);
                },
              ),
            ),
          ),
          const Divider(
            thickness: 2.0,
            color: Colors.black,
          ),
          const SizedBox(
            height: 25.0,
          )
        ],
      ),
    );
  }
}

Widget placedOrderDesignWidget(
    Items model, BuildContext context, itemQuantity) {
  return CartItemListTile(
    imageUrl: model.thumbnailUrl.toString(),
    itemName: model.title.toString(),
    itemPrice: model.price.toString(),
    itemEpa: model.epa.toString(),
    itemQuantity: int.parse(itemQuantity),
    onTapFunction: () {},
  );
}
