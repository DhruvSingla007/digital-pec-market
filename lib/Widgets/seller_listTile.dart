import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_major/constants.dart';

class IndSellerListTile extends StatelessWidget {
  final String imageUrl;
  final String memberName;
  final String memberEmailID;
  final String memberContact;
  final Function onTapFunction;
  // final String memberPosition;

  IndSellerListTile({
    required this.imageUrl,
    required this.memberName,
    required this.memberEmailID,
    required this.memberContact,
    required this.onTapFunction,
    // required this.memberPosition,
  });

  Widget makeListTile(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTapFunction();
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 150.0,
                  width: 100.0,
                  color: Colors.black,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: Container(
                        width: 150.0,
                        height: 100.0,
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
            Expanded(
              flex: 5,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            memberName,
                            style: const TextStyle(
                               fontWeight: FontWeight.bold,
                              fontFamily: "Kiwi",
                              fontSize: 20.0,
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
                            padding: EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.phone,
                              color: greenColor,
                              size: 15.0,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                memberContact,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.alternate_email,
                              color: greenColor,
                              size: 15.0,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                memberEmailID,
                                style: const TextStyle(
                                  fontSize: 15.0,
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
         ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        child: makeListTile(context),
      ),
    );
  }
}
