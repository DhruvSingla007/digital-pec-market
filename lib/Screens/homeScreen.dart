import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:user_major/Screens/menuScreen.dart';
import 'package:user_major/Widgets/drawer.dart';
import 'package:user_major/Widgets/progress_bar.dart';
import 'package:user_major/Widgets/seller_listTile.dart';

import '../Models/Sellers.dart';
import '../Widgets/info_design.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text("Digital PEC"),
        centerTitle: true,
      ),
      drawer: const HomePageDrawer(),
      body: SafeArea(
        child: ListView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("sellers").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final sellers = snapshot.data!.docs;
                  List<IndSellerListTile> sellerListTiles = [];
                  for (var seller in sellers) {
                    final String sellerName = seller.get("sellerName");
                    final String sellerEmail = seller.get("sellerEmail");
                    final String sellerContact = seller.get("sellerContact");
                    final String sellerUID = seller.get("sellerUID");
                    final String thumbnail = seller.get("thumbnail");
                    final sellerListTile = IndSellerListTile(
                      memberName: sellerName,
                      memberContact: sellerContact,
                      memberEmailID: sellerEmail,
                      imageUrl: thumbnail,
                      onTapFunction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => MenuScreen(
                              sellerUID: sellerUID,
                              sellerContact: sellerContact,
                            ),
                          ),
                        );
                      },
                    );

                    sellerListTiles.add(sellerListTile);
                  }
                  return Column(
                    children: sellerListTiles,
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
            )
          ],
        ),
      ),
    );
  }
}
