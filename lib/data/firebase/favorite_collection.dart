import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pbm_project1_uas/data/models/favorite_model.dart';
import 'package:uuid/uuid.dart';

class FavoriteCollection {
  //function untuk menambahkan ke data favorite
  static Future<bool> create(
      String uidUser,
      String idProduct,
      String strDrink,
      String strDrinkThumb,
      String strDescription,
      int price,
      double rating) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    final data = <String, dynamic>{
      'uidUser': uidUser,
      'idProduct': idProduct,
      'strProduct': strDrink,
      'strProductThumb': strDrinkThumb,
      'price': price,
      'rating': rating,
      'strDescription': strDescription
    };

    await db.collection('favorite').doc(const Uuid().v4()).set(data);

    return true;
  }

  //function untuk melihat data favorite berdasarkan uidUser
  static Future<List<FavoriteModel>> getFavorite(String uidUser) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    List<FavoriteModel> favorite = [];

    await db
        .collection('favorite')
        .where('uidUser', isEqualTo: uidUser)
        .get()
        .then((event) {
      for (var element in event.docs) {
        favorite.add(FavoriteModel.fromMap(element.data()));
      }
    });

    return favorite;
  }
}
