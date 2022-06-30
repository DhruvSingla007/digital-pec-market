import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_major/constants.dart';

class CartItemListTile extends StatelessWidget {
  final String imageUrl;
  final String itemName;
  final String itemPrice;
  final String itemEpa;
  final int itemQuantity;
  final Function onTapFunction;

  CartItemListTile({
    required this.imageUrl,
    required this.itemName,
    required this.itemPrice,
    required this.itemEpa,
    required this.itemQuantity,
    required this.onTapFunction,
  });

  Widget makeListTile(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 150.0,
              width: 100.0,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: Container(
                      width: 100.0,
                      height: 50.0,
                      child: const Center(
                        child: Text(
                          'Loading...',
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        itemName,
                        style: const TextStyle(
                          fontFamily: "Acme",
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Icon(
                          Icons.currency_rupee,
                          color: greenColor,
                          size: 18.0,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            "Rs. " + itemPrice,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "X " + itemQuantity.toString(),
                            style: const TextStyle(
                              color: greenColor,
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Icon(
                          Icons.timelapse,
                          color: greenColor,
                          size: 18.0,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            itemEpa + " mins",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: GestureDetector(
        onTap: () {
          onTapFunction();
        },
        child: Container(
          child: makeListTile(context),
        ),
      ),
    );
  }
}
