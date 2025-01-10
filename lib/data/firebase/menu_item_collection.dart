import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pbm_project1_uas/data/models/drink_model.dart';

class MenuItemCollection {
  //fungsi untuk mengambil data menu dari database
  static Future<List<DrinkModel>> getMenuItem() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    List<DrinkModel> list = [];
    await db.collection('drink').get().then((event) {
      for (var doc in event.docs) {
        list.add(DrinkModel.fromMap(doc.data()));
      }
    });
    return list;
  }
}
