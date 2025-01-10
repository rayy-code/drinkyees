import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pbm_project1_uas/data/firebase/cart_collection.dart';
import 'package:pbm_project1_uas/data/models/cart_model.dart';
import 'package:pbm_project1_uas/data/models/order_model.dart';
import 'package:uuid/uuid.dart';

class OrderCollection {
  static Future<bool> newOrder(String uidUser) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    List<CartModel> userCart = await CartCollection.read(uidUser);

    int totalPrice = 0;
    List<Map<String, dynamic>> dataCart = [];

    Map<String, dynamic> convertToMap(Object model) {
      if (model is CartModel) {
        return model.toMap();
      }
      throw Exception('Model type not supported');
    }

    for (var element in userCart) {
      totalPrice += element.totalPrice;
      dataCart.add(convertToMap(element));
    }

    final data = <String, dynamic>{
      'uidUser': uidUser,
      'status': 'pending',
      'menu': dataCart,
      'totalPrice': totalPrice,
      'date': DateTime.now(),
    };

    await db.collection('order').doc(const Uuid().v4()).set(data);
    for (var element in userCart) {
      CartCollection.deleteCart(element.idDrink, uidUser);
    }
    return true;
  }

  //function untuk membaca data order bedasarkan userID
  //fungsi untuk mengambil data order
  static Future<List<OrderModel>> getOrder(
      String uidUser, String orderStatus) async {
    List<OrderModel> orderList = [];
    final FirebaseFirestore db = FirebaseFirestore.instance;

    await db
        .collection("order")
        .where('status', isEqualTo: orderStatus)
        .where('uidUser', isEqualTo: uidUser)
        .get()
        .then((event) {
      for (var doc in event.docs) {
        //print("order : ${doc.id} => ${doc.data()}");
        orderList.add(OrderModel.fromMap(doc.data()));
        //total += int.parse(doc.data()["totalPrice"]!);
      }
    });

    return orderList;
  }
}
