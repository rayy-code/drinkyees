import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pbm_project1_uas/data/firebase/cart_collection.dart';
import 'package:pbm_project1_uas/data/firebase/order_collection.dart';
import 'package:pbm_project1_uas/data/models/cart_model.dart';
import 'package:pbm_project1_uas/helper/format_string.dart';
import 'package:pbm_project1_uas/views/history_order_page.dart';
import 'package:pbm_project1_uas/views/home_page.dart';
import 'package:pbm_project1_uas/views/payment.qris.dart';
import 'package:pbm_project1_uas/views/payment.transfer.dart';

class PaymentPage extends StatefulWidget {
  final String paymentMethod;

  const PaymentPage({super.key, required this.paymentMethod});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? uidUser;
  List<CartModel> dataCart = [];
  int totalPrice = 0;
  final _auth = FirebaseAuth.instance.currentUser;

  //mengecek atutentikasi
  Future<void> checkAuth() async {
    Future.delayed(Duration(seconds: 2), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          debugPrint("belum login");
          Navigator.pop(context);
        } else {
          setState(() {
            uidUser = user.uid;
          });
          debugPrint('User is logged in');
        }
      });
    });
  }

  //mengambil data cart
  Future<void> getData() async {
    debugPrint(_auth?.uid);
    dataCart = await CartCollection.read(_auth!.uid);
    int price = 0;
    for (var item in dataCart) {
      price += item.totalPrice;
    }
    setState(() {
      totalPrice = price;
      dataCart = dataCart;
      debugPrint("$dataCart");
    });
  }

  //menambahkan ke dalam order
  Future<void> addOrder() async {
    bool result = await OrderCollection.newOrder(_auth!.uid);
    if (result) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
        children: [
          const Text("Berhasil memesan. Lihat pesanan dalaman "),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HistoryOrderPage(
                          total: 0,
                        )));
              },
              child: const Text("Pesanan")),
        ],
      )));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Terjadi Masalah")));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //checkAuth();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Payment Page',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 44, 0, 241),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: widget.paymentMethod == "qris"
            ? PaymentQris(totalPrice: totalPrice, data: dataCart)
            : PaymentTransfer(totalPrice: totalPrice, data: dataCart),
        bottomSheet: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            height: 100,
            width: double.infinity,
            color: Colors.white,
            child: InkWell(
                onTap: () {
                  _auth != null ? addOrder() : null;
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )),
                    child: const Center(
                      child: Text(
                        "Sudah Bayar",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: const BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        )),
                    child: Center(
                      child: Text(
                        FormatString.toRupiah(totalPrice),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ]))));
  }
}
