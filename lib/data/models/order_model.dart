import 'package:pbm_project1_uas/data/models/cart_model.dart';

class OrderModel {
  final List<CartModel> menu;
  final String status;
  final int totalPrice;
  final String uidUser;
  final DateTime date;

  const OrderModel({
    required this.menu,
    required this.status,
    required this.totalPrice,
    required this.uidUser,
    required this.date,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      menu: List<CartModel>.from(map['menu'].map((x) => CartModel.fromMap(x))),
      status: map['status'],
      totalPrice: map['totalPrice'],
      uidUser: map['uidUser'],
      date: map['date'].toDate(),
    );
  }
}
