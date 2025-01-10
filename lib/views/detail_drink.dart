import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pbm_project1_uas/data/firebase/cart_collection.dart';
import 'package:pbm_project1_uas/data/firebase/favorite_collection.dart';
import 'package:pbm_project1_uas/data/models/favorite_model.dart';
import 'package:pbm_project1_uas/helper/format_string.dart';

class DetailDrink extends StatefulWidget {
  const DetailDrink(
      {super.key,
      required this.idDrink,
      required this.strDrink,
      required this.strDrinkThumb,
      required this.price,
      required this.strDescription,
      required this.rating});

  final String idDrink;
  final String strDrink;
  final String strDrinkThumb;
  final int price;
  final String strDescription;
  final double rating;

  @override
  State<DetailDrink> createState() => _DetailDrinkState();
}

class _DetailDrinkState extends State<DetailDrink> {
  int total = 1;
  var db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance.currentUser;
  late bool isFavorite = false;
  //late DrinkModel drinkData = DrinkModel(idDrink: "idDrink", strDrink: "strDrink", price: 1, strDrinkThumb: "strDrinkThumb");
  int totalPrice = 0;

  Future<void> addToFirestore(String idProduct, int quantity, int price) async {
    await CartCollection.create(_auth!.uid, widget.idDrink, widget.strDrink,
        widget.strDrinkThumb, quantity, price, totalPrice);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil menambahkan ke keranjang")));
  }

  //mengambil data favorite
  Future<void> getFavorite() async {
    List<FavoriteModel> favoriteList =
        await FavoriteCollection.getFavorite(_auth!.uid);
    for (var element in favoriteList) {
      if (element.idProduct == widget.idDrink) {
        setState(() {
          isFavorite = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //getData();
    totalPrice = widget.price;
    getFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 141, 141, 141),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(
                _auth != null && isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                color: Colors.red,
              ),
              onPressed: () {
                // Add to favorites
                if (_auth != null) {
                  FavoriteCollection.create(
                      _auth.uid,
                      widget.idDrink,
                      widget.strDrink,
                      widget.strDrinkThumb,
                      widget.strDescription,
                      widget.price,
                      widget.rating);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Berhasil menambahkan ke favorite")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "Anda belum login, silahkan login terlebih dahulu")));
                }
              },
            )
          ],
        ),
        body: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: const Color.fromARGB(255, 44, 0, 241),
              ),
              child: Hero(
                  transitionOnUserGestures: true,
                  tag: widget.strDrinkThumb,
                  child: Image(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/${widget.strDrinkThumb}"),
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 300,
                  )),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: 250,
                    child: Text(
                      widget.strDrink,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.fade),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          // Minimize
                          setState(() {
                            if (total > 1) {
                              total -= 1;
                              totalPrice -= widget.price;
                            }
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.amber),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.black),
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    side: BorderSide(color: Colors.amber)))),
                      ),
                      Text("$total",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black)),
                      IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              total += 1;
                              totalPrice += widget.price;
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.amber),
                              foregroundColor:
                                  WidgetStateProperty.all(Colors.black),
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      side: BorderSide(color: Colors.amber))))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: RatingBar.builder(
                      initialRating: widget.rating,
                      minRating: 1,
                      maxRating: 5,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 16,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      onRatingUpdate: (index) {},
                    ),
                  ),
                  Text(
                    FormatString.toRupiah(totalPrice),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.fade),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: const Text(
                "Description",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.fade),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                widget.strDescription,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    overflow: TextOverflow.fade),
              ),
            )
          ],
        ),
        bottomSheet: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            height: 100,
            width: double.infinity,
            color: Colors.white,
            child: InkWell(
              onTap: () {
                _auth != null
                    ? addToFirestore(widget.idDrink, total, totalPrice)
                    : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Anda belum login, silahkan login terlebih dahulu")));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        "Add to cart",
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
                  ),
                ],
              ),
            )));
  }
}

// ElevatedButton(
//           onPressed: () {

//           },
//           child: Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   color: Colors.cyanAccent,
//                   child: Text("Bayar"),
//                 ),
//               ),
//               Text("Total $total")
//             ],
//           ),
//         )
