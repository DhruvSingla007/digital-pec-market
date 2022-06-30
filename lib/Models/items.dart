import 'package:cloud_firestore/cloud_firestore.dart';

class Items
{
  String? menuID;
  String? sellerUID;
  String? itemID;
  String? title;
  String? shortInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? longDescription;
  String? status;
  String? price;
  String? epa;

  Items({
    this.menuID,
    this.sellerUID,
    this.itemID,
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    this.epa,
    this.price,
  });

  Items.fromJson(Map<String, dynamic> json)
  {
    menuID = json['menuUID'];
    sellerUID = json['sellerUID'];
    itemID = json['itemUID'];
    title = json['itemTitle'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnail'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
    epa = json['epa'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['menuUID'] = menuID;
    data['sellerUID'] = sellerUID;
    data['itemUID'] = itemID;
    data['itemTitle'] = title;
    data['shortInfo'] = shortInfo;
    data['price'] = price;
    data['publishedDate'] = publishedDate;
    data['thumbnail'] = thumbnailUrl;
    data['longDescription'] = longDescription;
    data['status'] = status;
    data['epa'] = epa;

    return data;
  }
}