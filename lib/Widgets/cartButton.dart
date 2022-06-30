import 'package:flutter/material.dart';

import '../Screens/cartScreen.dart';

Widget CartButton({required BuildContext context}){
  return IconButton(
    onPressed: () {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (c) => CartScreen(
      //       //sellerUID: widget.menu.sellerUID.toString(),
      //     ),
      //   ),
      // );
    },
    icon: const Icon(Icons.shopping_cart),
  );
}