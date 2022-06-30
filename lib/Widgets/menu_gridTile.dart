import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MenuGridTile extends StatelessWidget {
  final String menuTitle;
  final String menuInfo;
  final String imageUrl;
  final BuildContext context;
  final Function onTapFunction;

  MenuGridTile({
    required this.menuTitle,
    required this.menuInfo,
    required this.imageUrl,
    required this.context,
    required this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onTapFunction();
        },
        child: Container(
          // decoration: const BoxDecoration(
          //   // color: Colors.grey,
          //   // borderRadius: BorderRadius.all(
          //   //   Radius.circular(20),
          //   // ),
          // ),
          //height: 300,
          width: MediaQuery.of(context).size.width,
          child: Card(
            //color: Colors.grey[700],
            elevation: 10,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: CachedNetworkImage(
                      height: 175,
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width - 10,
                      //height: 300,
                      placeholder: (context, url) => const Center(
                        child: Text(
                          'Loading...',
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    menuTitle,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontFamily: "Acme",
                      fontSize: 20,
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                //   child: Text(
                //     menuInfo,
                //     textAlign: TextAlign.justify,
                //     style: const TextStyle(
                //       //fontWeight: FontWeight.bold,
                //       fontFamily: "Kiwi",
                //       fontSize: 15,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
