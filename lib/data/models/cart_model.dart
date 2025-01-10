import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  int quantity;
  final String idDrink;
  final String strDrink;
  final String strDrinkThumb;
  int price;
  int totalPrice;
  //final DateTime datetime;

  CartModel(
      {required this.quantity,
      required this.idDrink,
      required this.totalPrice,
      //required this.datetime,
      required this.strDrink,
      required this.strDrinkThumb,
      required this.price});

  factory CartModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CartModel(
      idDrink: data?['idDrink'],
      quantity: data?['quantity'],
      totalPrice: data?['totalPrice'],
      //datetime: data?['datetime'],
      strDrink: data?['strDrink'],
      strDrinkThumb: data?['strDrinkThumb'],
      price: data?['price'],
    );
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      quantity: map['quantity'],
      totalPrice: map['totalPrice'],
      //datetime: map['datetime'],
      idDrink: map['idDrink'],
      strDrink: map['strDrink'],
      strDrinkThumb: map['strDrinkThumb'],
      price: map['price'],
    );
  }

  //to map
  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'totalPrice': totalPrice,
      // 'datetime': datetime,
      'idDrink': idDrink,
      'strDrink': strDrink,
      'strDrinkThumb': strDrinkThumb,
      'price': price,
    };
  }
}
