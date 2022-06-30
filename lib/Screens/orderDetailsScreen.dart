import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:user_major/Screens/myOrdersScreen.dart';
import 'package:user_major/constants.dart';

import '../Widgets/progress_bar.dart';
import '../global.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderID;

  OrderDetailsScreen({required this.orderID});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String orderStatus = "";
  String orderPrice = "";
  String? sellerUID;

  Future<void> checkAndUpdateStatus() async {
    String sellerOrderStatus = "new";

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerUID)
        .collection("orders")
        .doc(widget.orderID)
        .get()
        .then((snap) {
      sellerOrderStatus = snap.data()!["status"];
    }).whenComplete(() async {
      if(sellerOrderStatus != "completed") {
        Fluttertoast.showToast(msg: "Your order is not prepared yet.");
        return;
      }
      await FirebaseFirestore.instance
          .collection("users")
          .doc(sharedPreferences!.getString("userUID"))
          .collection("orders")
          .doc(widget.orderID)
          .update({
        "status": "completed",
      }).whenComplete(() async {
        final ref =
            FirebaseFirestore.instance.collection("sellers").doc(sellerUID);

        num earnings = 0;
        await ref.get().then((snapshot) {
          earnings = snapshot.data()!["earnings"];
        }).then((value) async {
          num _totalEarnings =
              num.parse(earnings.toString()) + num.parse(orderPrice);
          //print("=====" + _totalEarnings.toString());
          await FirebaseFirestore.instance
              .collection("sellers")
              .doc(sellerUID)
              .update({
            "earnings": _totalEarnings,
          });
          Fluttertoast.showToast(msg: "Order received successfully");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (c) => MyOrdersScreen()),
              (route) => false);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(sharedPreferences!.getString("userUID"))
              .collection("orders")
              .doc(widget.orderID)
              .get(),
          builder: (c, snapshot) {
            Map? dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data!.data()! as Map<String, dynamic>;
              orderStatus = dataMap["status"].toString() == "new"
                  ? "approval pending"
                  : dataMap["status"].toString();
              orderPrice = dataMap["totalAmount"].toString();
              sellerUID = dataMap["sellerUID"].toString();
            }
            return snapshot.hasData
                ? Container(
                    child: Column(
                      children: [
                        // StatusBanner(
                        //   status: dataMap!["isSuccess"],
                        //   orderStatus: orderStatus,
                        // ),
                        const SizedBox(
                          height: 10.0,
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
                                  "Total Amount :  ₹" +
                                      dataMap!["totalAmount"].toString(),
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
                                  "Total ETP : " +
                                      dataMap["totalEPA"].toString() +
                                      " mins.",
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
                          child: Text(
                            "Order Id = " + widget.orderID!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Order placed at: " +
                                DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(dataMap["orderTime"]),
                                  ),
                                ),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),

                        orderStatus == "completed"
                            ? Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset("images/success.gif"),
                              )
                            : orderStatus == "active"
                                ? Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset("images/cooking.gif"),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset("images/pizza.gif"),
                                  ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "STATUS  :  " + orderStatus.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Acme",
                                color: orderStatus == "active"
                                    ? greenColor
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        orderStatus == "active"
                            ? ElevatedButton(
                                onPressed: () {
                                  checkAndUpdateStatus();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "Confirm Received",
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                ),
                              )
                            : const Text(""),
                      ],
                    ),
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
