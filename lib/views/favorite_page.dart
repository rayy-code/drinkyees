import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pbm_project1_uas/data/firebase/cart_collection.dart';
import 'package:pbm_project1_uas/data/firebase/favorite_collection.dart';
import 'package:pbm_project1_uas/data/models/favorite_model.dart';
import 'package:pbm_project1_uas/views/components/card_drink.dart';
import 'package:pbm_project1_uas/views/detail_drink.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final _auth = FirebaseAuth.instance.currentUser;
  List<FavoriteModel> favoriteList = [];

  //Function untuk mengambil data favorite dari Firebase
  Future<void> getFavorite() async {
    List<FavoriteModel> list = [];
    list = await FavoriteCollection.getFavorite(_auth!.uid);
    setState(() {
      favoriteList = list;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _auth != null
            ? favoriteList.isNotEmpty
                ? GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 8),
                    itemCount: favoriteList.length,
                    itemBuilder: (context, index) => CardDrink(
                          idDrink: favoriteList[index].idProduct,
                          name: favoriteList[index].strProduct,
                          rating: favoriteList[index].rating,
                          price: favoriteList[index].price,
                          imgDrink: favoriteList[index].strProductThumb,
                          onAdd: () {
                            CartCollection.create(
                                _auth.uid,
                                favoriteList[index].idProduct,
                                favoriteList[index].strProduct,
                                favoriteList[index].strProductThumb,
                                1,
                                favoriteList[index].price,
                                favoriteList[index].price);
                          },
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DetailDrink(
                                      idDrink: favoriteList[index].idProduct,
                                      strDrink: favoriteList[index].strProduct,
                                      strDrinkThumb:
                                          favoriteList[index].strProductThumb,
                                      price: favoriteList[index].price,
                                      strDescription:
                                          favoriteList[index].strDescription,
                                      rating: favoriteList[index].rating,
                                    )));
                            //Navigator.pushNamed(context, "/detail", arguments: index);
                          },
                        ))
                : const Center(
                    child: Text("Belum ada favorit"),
                  )
            : const Center(
                child: Text("Anda Belum login"),
              ));
  }
}
