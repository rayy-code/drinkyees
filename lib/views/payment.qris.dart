import 'package:flutter/material.dart';
import 'package:pbm_project1_uas/data/models/cart_model.dart';
import 'package:pbm_project1_uas/helper/format_string.dart';

class PaymentQris extends StatelessWidget {
  final int totalPrice;
  final List<CartModel> data;

  const PaymentQris({super.key, required this.totalPrice, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: 500,
          height: 350,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  scale: 1.0, image: AssetImage("assets/images/frame.png"))),
        ),
        const Center(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "drinkyes",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text("Silahkan bayar dengan QRIS di atas"),
              SizedBox(height: 20.0),
            ],
          ),
        )),
        ListView.builder(
            itemCount: data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => Card(
                  child: ListTile(
                    tileColor: Colors.white,
                    leading: Container(
                      width: 30,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                "assets/images/${data[index].strDrinkThumb}"),
                            scale: 1.0),
                      ),
                    ),
                    title: Text(
                      data[index].strDrink,
                    ),
                    subtitle: Text("(${data[index].quantity})"),
                    trailing: Text(
                      FormatString.toRupiah(data[index].totalPrice),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ))
      ],
    );
  }
}
