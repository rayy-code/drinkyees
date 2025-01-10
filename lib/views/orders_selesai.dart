import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbm_project1_uas/data/models/order_model.dart';
import 'package:pbm_project1_uas/views/components/card_order.dart';

class OrdersSelesai extends StatefulWidget {
  final List<OrderModel> data;
  const OrdersSelesai({super.key, required this.data});

  @override
  State<OrdersSelesai> createState() => _OrdersSelesaiState();
}

class _OrdersSelesaiState extends State<OrdersSelesai> {
  final _auth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.data.isNotEmpty && _auth != null
            ? ListView.builder(
                itemCount: widget.data.length,
                itemBuilder: (context, index) => CardOrder(
                    status: widget.data[index].status,
                    idOrder: DateFormat('dd MMMM yyyy HH:mm:ss')
                        .format(DateTime.now())
                        .toString(),
                    order: widget.data[index].menu,
                    total: widget.data[index].totalPrice),
              )
            : const Center(
                child: Text("Belum ada pesanan"),
              ));
  }
}
