import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:pbm_project1_uas/data/firebase/user_authentication.dart';
import 'package:pbm_project1_uas/data/models/drink_model.dart';
import 'package:pbm_project1_uas/data/models/order_model.dart';
import 'package:pbm_project1_uas/views/cart_page.dart';

import 'package:pbm_project1_uas/views/dashboard.dart';

import 'package:pbm_project1_uas/views/favorite_page.dart';
import 'package:pbm_project1_uas/views/history_order_page.dart';
import 'package:pbm_project1_uas/views/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int cartTotal = 0;
  int pageIndex = 0;
  final _auth = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;
  List<DrinkModel> drinkList = [];
  List<OrderModel> orderList = [];
  //late User currentUser;
  late String emailuser = "";
  late String uidUser = "";
  User? user;
  //mengecek atutentikasi

  //mengecek autentikasi kedua
  Future<void> checkAuth2() async {
    user = await UserAuthentication.checkAuth();
    setState(() {
      user = user;
      emailuser = user!.email!;
    });
  }

  //fungsi untuk melakukan signout/logout
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/login');
  }

  //mengambil data dari firebase
  Future<void> getData() async {
    await db.collection("drink").get().then((event) {
      for (var doc in event.docs) {
        //print("drink : ${doc.id} => ${doc.data()}");
        drinkList.add(DrinkModel.fromMap(doc.data()));
      }
      //debugPrint("$drinkList");
    });
    debugPrint("${_auth!.email}");
    setState(() {
      drinkList = drinkList;
    });
  }

  //fungsi untuk mengambil data order
  Future<void> getOrder() async {
    int total = 0;
    await db
        .collection("order")
        .where('status', isEqualTo: 'pending')
        .get()
        .then((event) {
      for (var doc in event.docs) {
        //print("order : ${doc.id} => ${doc.data()}");
        orderList.add(OrderModel.fromMap(doc.data()));
        //total += int.parse(doc.data()["totalPrice"]!);
      }
    });
    debugPrint('$orderList');
    setState(() {
      //cartTotal = cartTotal + int.parse(doc.data()['total']!);
      orderList = orderList;
      cartTotal = total;
    });
  }

  //inisialisa
  @override
  void initState() {
    super.initState();
    //checkAuth();
    //getOrder();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _auth == null
              ? const Text('Hello, user')
              : Text(
                  "${_auth.email}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
          backgroundColor: const Color.fromARGB(255, 141, 141, 141),
          foregroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              debugPrint("Masuk ke halaman profile");
            },
            child: Container(
              padding: const EdgeInsets.all(5.0),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      onError: (exception, stackTrace) {
                        const Icon(Icons.person);
                      },
                      fit: BoxFit.fill,
                      image: const NetworkImage('https://picsum.photos/15/15',
                          scale: 1.0))),
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            _auth != null
                ? IconButton(
                    icon: const Icon(
                      Icons.logout,
                      size: 20,
                    ),
                    onPressed: signOut,
                  )
                : IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    icon: const Icon(Icons.door_front_door),
                  ),
            // IconButton(
            //   icon: const Icon(Icons.refresh),
            //   onPressed: getData,
            // ),
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                _auth != null
                    ? Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CartPage()))
                    : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Anda belum login, silahkan login terlebih dahulu")));
              },
            ),
          ],
        ),
        body: <Widget>[
          Dashboard(drinkList: drinkList),
          _auth != null
              ? HistoryOrderPage(total: cartTotal)
              : Center(
                  child: Text('Anda Belum Login'),
                ),
          const FavoritePage(),
          const Profile()
        ][pageIndex],
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: GNav(
              backgroundColor: Colors.white,
              color: Colors.black38,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.lightBlueAccent,
              padding: const EdgeInsets.all(16.0),
              gap: 8,
              selectedIndex: pageIndex,
              onTabChange: (int index) {
                setState(() {
                  pageIndex = index;
                });
              },
              tabs: [
                const GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
                  onPressed: getOrder,
                  icon: Icons.list,
                  text: "Orders",
                ),
                const GButton(
                  icon: Icons.favorite,
                  text: "Favorite",
                ),
                const GButton(
                  icon: Icons.person,
                  text: "Profile",
                ),
              ],
            ),
          ),
        ));
  }
}

// NavigationBar(
//         onDestinationSelected: (int index) {
//           setState(() {
//             pageIndex = index;
//           });
//         },
//         selectedIndex: pageIndex,
//         destinations: const [
//           NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
//           NavigationDestination(icon: Icon(Icons.list_alt), label: 'history'),
//           NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorite'),
//         ],
//       ),
