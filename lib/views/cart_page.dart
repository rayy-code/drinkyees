import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pbm_project1_uas/data/firebase/cart_collection.dart';
import 'package:pbm_project1_uas/data/models/cart_model.dart';
import 'package:pbm_project1_uas/helper/format_string.dart';
import 'package:pbm_project1_uas/views/payment.page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _auth = FirebaseAuth.instance;
  String? selectedPaymentMethod;

  var db = FirebaseFirestore.instance;
  List<CartModel> cartList = [];
  int totalOrder = 0;
  TextEditingController promoCode = TextEditingController();

  Future<void> getData() async {
    cartList = await CartCollection.read(_auth.currentUser!.uid);
    debugPrint("uid User :  ${_auth.currentUser!.uid}");
    for (var i = 0; i < cartList.length; i++) {
      totalOrder += cartList[i].totalPrice;
    }
    setState(() {
      cartList = cartList;
    });
  }

  void increment(String idProduct, int index) async {
    //memperbarui data di lokal
    setState(() {
      cartList[index].quantity++;
      cartList[index].totalPrice += cartList[index].price;
      totalOrder += cartList[index].price;
    });
    //memperbarui data di firebase
    await CartCollection.incrementQuantity(idProduct, _auth.currentUser!.uid);
  }

  void decrement(String idProduct, int index) async {
    if (cartList[index].quantity > 1 && cartList[index].idDrink == idProduct) {
      setState(() {
        cartList[index].quantity--;
        cartList[index].totalPrice -= cartList[index].price;
        totalOrder -= cartList[index].price;
      });
      await CartCollection.decrementQuantity(idProduct, _auth.currentUser!.uid);
    } else {
      setState(() {
        totalOrder -= cartList[index].price;
        cartList.removeAt(index);
      });
      await CartCollection.deleteCart(idProduct, _auth.currentUser!.uid);
    }
  }

  final List<Map<dynamic, dynamic>> paymentMethod = [
    {
      'value': 'qris',
      IconData: Icons.qr_code_scanner,
      'text': 'QRIS',
    },
    {
      'value': 'bank',
      IconData: Icons.account_balance,
      'text': 'Transfer Bank',
    },
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 44, 0, 241),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.delete))],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: ListView(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartList.length,
                itemBuilder: (context, index) => ListTile(
                      leading: Image(
                        image: AssetImage(
                            "assets/images/${cartList[index].strDrinkThumb}"),
                        width: 80,
                        height: 80,
                      ),
                      title: SizedBox(
                        width: 200,
                        child: Text(
                          cartList[index].strDrink,
                          style: const TextStyle(
                              overflow: TextOverflow.fade,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          decrement(
                                              cartList[index].idDrink, index);
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    Colors.amber),
                                            foregroundColor:
                                                WidgetStateProperty.all(
                                                    Colors.black),
                                            shape: MaterialStateProperty.all(
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                    side: BorderSide(
                                                        color: Colors.amber)))),
                                        icon:
                                            const Icon(Icons.remove, size: 10)),
                                    Text("${cartList[index].quantity}"),
                                    IconButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    Colors.amber),
                                            foregroundColor:
                                                WidgetStateProperty.all(
                                                    Colors.black),
                                            shape: MaterialStateProperty.all(
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                    side: BorderSide(
                                                        color: Colors.amber)))),
                                        onPressed: () {
                                          increment(
                                              cartList[index].idDrink, index);
                                        },
                                        icon: const Icon(Icons.add, size: 10)),
                                  ],
                                ),
                              ),
                              Text(
                                FormatString.toRupiah(
                                    cartList[index].totalPrice),
                                style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              )
                            ],
                          ),
                          TextField(
                              style: TextStyle(),
                              decoration:
                                  InputDecoration(label: Text('notes'))),
                        ],
                      ),
                    ))
          ],
        ),
      ),
      bottomSheet: Container(
        height: 150.0,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurStyle: BlurStyle.outer)
            ]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: DropdownButton(
                      value: selectedPaymentMethod,
                      hint: Text("Method payment"),
                      items: paymentMethod.map((item) {
                        return DropdownMenuItem<String>(
                            value: item['value'],
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    item[IconData],
                                    color: Colors.green,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(item['text'])
                                ]));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value;
                        });
                      }),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: const TextField(
                      style: TextStyle(),
                      decoration: InputDecoration(label: Text('ADD A PROMO'))),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text("Total : ${FormatString.toRupiah(totalOrder)}"),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ))),
                      onPressed: () {
                        if (selectedPaymentMethod != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PaymentPage(
                                    paymentMethod: selectedPaymentMethod!,
                                  )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Pilih metode pembayaran dahulu")));
                        }
                      },
                      child: Text("Order")),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
