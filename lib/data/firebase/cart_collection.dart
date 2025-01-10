import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pbm_project1_uas/data/models/cart_model.dart';
import 'package:uuid/uuid.dart';

class CartCollection {
  //fungsi untuk menambahkan data ke firestore
  static Future<bool> create(String uidUser, String idDrink, String strDrink,
      String strDrinkThumb, int quantity, int price, int totalPrice) async {
    //mengecek apakah data sudah ada
    String idCart = await getDocumentId(idDrink, uidUser);

    //validasi
    if (idCart == "") {
      //instansiasi firebase
      final db = FirebaseFirestore.instance;

      //membuat data untuk dikirim
      final data = <String, dynamic>{
        'uidUser': uidUser,
        'idDrink': idDrink,
        'strDrink': strDrink,
        'strDrinkThumb': strDrinkThumb,
        'price': price,
        'quantity': quantity,
        'totalPrice': totalPrice,
        'datetime': Timestamp.now(),
      };

      //mengirim data ke firestore
      await db.collection('cart').doc(const Uuid().v4()).set(data);
    } else {
      //update data
      bool upd = await update(idCart, quantity, idDrink);
      return upd;
    }

    //mengembalikan nilai true
    return true;
  }

  static Future<String> getDocumentId(String idDrink, String uidUser) async {
    String idCart = "";
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .where('idDrink', isEqualTo: idDrink)
        .where('uidUser', isEqualTo: uidUser)
        .get();
    for (var doc in querySnapshot.docs) {
      idCart = doc.id;
    }
    debugPrint(idCart);
    return idCart;
  }

  static Future<bool> deleteCart(String idDrink, String uidUser) async {
    String idCart = await getDocumentId(idDrink, uidUser);
    await FirebaseFirestore.instance.collection('cart').doc(idCart).delete();
    return true;
  }

  //method update data
  static Future<bool> update(
      String documentId, int quantity, String idDrink) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      await db.runTransaction((transaction) async {
        //dapatkan referensi dokumen
        DocumentReference documentReference =
            db.collection('cart').doc(documentId);

        //baca data saat ini
        DocumentSnapshot documentSnapshot =
            await transaction.get(documentReference);

        if (!documentSnapshot.exists) {
          throw Exception("Dokumen tidak ditemukan");
        }

        // Ambil nilai quantity saat ini
        int currentQuantity = documentSnapshot.get('quantity');

        //ambil data price
        int price = documentSnapshot.get('price');

        // Hitung nilai baru
        int updatedQuantity = currentQuantity + quantity;

        int updatedPrice = updatedQuantity * price;

        // Update nilai di Firestore
        transaction.update(documentReference,
            {'quantity': updatedQuantity, 'totalPrice': updatedPrice});
      });
    } catch (e) {
      print('Error update data: $e');
      return false;
    }
    return true;
  }

  static Future<List<CartModel>> read(String uidUser) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    List<CartModel> list = [];
    await db
        .collection('cart')
        .where('uidUser', isEqualTo: uidUser)
        .get()
        .then((event) {
      for (var element in event.docs) {
        list.add(CartModel.fromMap(element.data()));
      }
    });

    return list;
  }

  //method increment
  static Future<void> incrementQuantity(String idDrink, String uidUser) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    String documentId = await getDocumentId(idDrink, uidUser);

    try {
      await db.runTransaction((transaction) async {
        //dapatkan referensi dokumen
        DocumentReference documentReference =
            db.collection('cart').doc(documentId);

        //baca data saat ini
        DocumentSnapshot documentSnapshot =
            await transaction.get(documentReference);

        if (!documentSnapshot.exists) {
          throw Exception("Dokumen tidak ditemukan");
        }

        // Ambil nilai quantity saat ini
        int currentQuantity = documentSnapshot.get('quantity');

        //ambil data price
        int price = documentSnapshot.get('price');

        // Hitung nilai baru
        int updatedQuantity = currentQuantity + 1;

        int updatedPrice = updatedQuantity * price;

        // Update nilai di Firestore
        transaction.update(documentReference,
            {'quantity': updatedQuantity, 'totalPrice': updatedPrice});
      });
    } catch (e) {
      print('Error update data: $e');
    }
  }

  //method decrement
  static Future<void> decrementQuantity(String idDrink, String uidUser) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    String documentId = await getDocumentId(idDrink, uidUser);
    try {
      await db.runTransaction((transaction) async {
        //dapatkan referensi dokumen
        DocumentReference documentReference =
            db.collection('cart').doc(documentId);

        //baca data saat ini
        DocumentSnapshot documentSnapshot =
            await transaction.get(documentReference);

        if (!documentSnapshot.exists) {
          throw Exception("Dokumen tidak ditemukan");
        }

        // Ambil nilai quantity saat ini
        int currentQuantity = documentSnapshot.get('quantity');

        //ambil data price
        int price = documentSnapshot.get('price');

        // Hitung nilai baru
        int updatedQuantity = currentQuantity - 1;

        int updatedPrice = updatedQuantity * price;

        // Update nilai di Firestore
        transaction.update(documentReference,
            {'quantity': updatedQuantity, 'totalPrice': updatedPrice});
      });
    } catch (e) {
      print('Error update data: $e');
    }
  }
}
