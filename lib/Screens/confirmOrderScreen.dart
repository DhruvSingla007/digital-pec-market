import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_major/Screens/homeScreen.dart';
import 'package:user_major/assistantMethods/assistant_methods.dart';
import 'package:user_major/global.dart';

class ConfirmOrderScreen extends StatefulWidget {
  final num totalAmount;
  final num totalEPA;
  final String sellerUID;

  ConfirmOrderScreen({
    required this.totalAmount,
    required this.totalEPA,
    required this.sellerUID,
  });

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  addOrderDetails() {
    writeOrderDetailsForUser({
      "totalAmount": widget.totalAmount,
      "totalEPA": widget.totalEPA,
      "orderBy": sharedPreferences!.getString("userUID"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "orderTime": orderID,
      "status": "new",
      "sellerUID": widget.sellerUID,
      "isSuccess": "isSuccess",
      "orderID": orderID,
    });

    writeOrderDetailsForSeller({
      "totalAmount": widget.totalAmount,
      "totalEPA": widget.totalEPA,
      "orderBy": sharedPreferences!.getString("userUID"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "orderTime": orderID,
      "status": "new",
      "sellerUID": widget.sellerUID,
      "isSuccess": "isSuccess",
      "orderID": orderID,
    }).whenComplete(() {
      clearCartNow(context);
      setState(() {
        orderID = "";
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (c) => HomeScreen()), (route) => false);
        Fluttertoast.showToast(msg: "Order has been placed successfully");
      });
    });
  }

  String orderID = DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("userUID"))
        .collection("orders")
        .doc(orderID)
        .set(data);
  }

  Future<void> writeOrderDetailsForSeller(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerUID)
        .collection("orders")
        .doc(orderID)
        .set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EAF0),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset("images/total.gif"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Total Amount :  ₹" + widget.totalAmount.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        fontFamily: "Acme"),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Total ETP : " + widget.totalEPA.toString() + " mins.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        fontFamily: "Acme"),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () {
                addOrderDetails();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Confirm Order",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
