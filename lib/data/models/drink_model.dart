import 'package:cloud_firestore/cloud_firestore.dart';

class DrinkModel {

  final String idDrink;
  final String strDrink;
  final int price;
  final String strDrinkThumb;
  final String strDescription;
  final double rating;

  const DrinkModel({
    required this.idDrink,
    required this.strDrink,
    required this.price,
    required this.strDrinkThumb,
    required this.strDescription,
    required this.rating,
  });

  factory DrinkModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return DrinkModel(
      idDrink: data?['idDrink'],
      strDrink: data?['strDrink'],
      strDrinkThumb : data?['strDrinkThumb'],
      price: data?['price'],
      strDescription: data?['strDescription'],
      rating: data?['rating'],
    );
  }

  factory DrinkModel.fromMap(Map<String, dynamic>map){
    return DrinkModel(

      idDrink: map['idDrink'] as String,
      strDrink: map['strDrink'] as String,
      strDrinkThumb: map['strDrinkThumb'] as String,
      price: map['price'].toInt(),
      strDescription: map['strDescription'] as String,
      rating: map['rating'].toDouble(),

    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (idDrink != null) "idDrink": idDrink,
      if (strDrink != null) "strDrink": strDrink,
      if (strDrinkThumb != null) "strDrinkThumb": strDrinkThumb,
      if (price != null) "price": price,
      if (strDescription != null) "strDescription": strDescription,
      if (rating != null) "rating": rating,
    };
  }
  // Method untuk konversi Model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'idDrink': idDrink,
      'strDrink': strDrink,
      'strDrinkThumb': strDrinkThumb,
      'price' : price,
      'strDescription': strDescription,
      'rating': rating,
    };
  }
}