import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pbm_project1_uas/data/firebase/cart_collection.dart';
import 'package:pbm_project1_uas/data/models/drink_model.dart';
import 'package:pbm_project1_uas/views/components/card_drink.dart';
import 'package:pbm_project1_uas/views/components/card_menu_popular.dart';
import 'package:pbm_project1_uas/views/detail_drink.dart';

class Dashboard extends StatefulWidget {
  final List<DrinkModel> drinkList;
  const Dashboard({super.key, required this.drinkList});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _auth = FirebaseAuth.instance.currentUser;
  Future<void> addToCart(index) async {
    if (_auth != null) {
      CartCollection.create(
          _auth.uid,
          widget.drinkList[index].idDrink,
          widget.drinkList[index].strDrink,
          widget.drinkList[index].strDrinkThumb,
          1,
          widget.drinkList[index].price,
          widget.drinkList[index].price);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil ditambahkan ke keranjang")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Anda belum login, silahkan login terlebih dahulu")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: Container(
              width: double.infinity,
              height: 200.0,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/poster1.webp"),
                      fit: BoxFit.fill)),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Most Popular",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20.0),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView.builder(
                itemCount: 2,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5.0),
                    child: CardMenuPopular(
                      idDrink: widget.drinkList[index].idDrink,
                      name: widget.drinkList[index].strDrink,
                      imgDrink: widget.drinkList[index].strDrinkThumb,
                      price: widget.drinkList[index].price,
                      rating: widget.drinkList[index].rating,
                      onAdd: () {
                        addToCart(index);
                      },
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailDrink(
                                  idDrink: widget.drinkList[index].idDrink,
                                  strDrink: widget.drinkList[index].strDrink,
                                  strDrinkThumb:
                                      widget.drinkList[index].strDrinkThumb,
                                  price: widget.drinkList[index].price,
                                  strDescription:
                                      widget.drinkList[index].strDescription,
                                  rating: widget.drinkList[index].rating,
                                )));
                        //Navigator.pushNamed(context, "/detail", arguments: index);
                      },
                    ))),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Menu Item",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20.0),
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 5.0),
            itemCount: widget.drinkList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: CardDrink(
                  idDrink: widget.drinkList[index].idDrink,
                  name: widget.drinkList[index].strDrink,
                  imgDrink: widget.drinkList[index].strDrinkThumb,
                  price: widget.drinkList[index].price,
                  rating: widget.drinkList[index].rating,
                  onAdd: () {
                    _auth != null
                        ? CartCollection.create(
                            _auth.uid,
                            widget.drinkList[index].idDrink,
                            widget.drinkList[index].strDrink,
                            widget.drinkList[index].strDrinkThumb,
                            1,
                            widget.drinkList[index].price,
                            widget.drinkList[index].price)
                        : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Anda belum login, silahkan login terlebih dahulu")));
                  },
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailDrink(
                              idDrink: widget.drinkList[index].idDrink,
                              strDrink: widget.drinkList[index].strDrink,
                              strDrinkThumb:
                                  widget.drinkList[index].strDrinkThumb,
                              price: widget.drinkList[index].price,
                              strDescription:
                                  widget.drinkList[index].strDescription,
                              rating: widget.drinkList[index].rating,
                            )));
                    //Navigator.pushNamed(context, "/detail", arguments: index);
                  },
                )),
          )
        ],
      ),
    );
  }
}
