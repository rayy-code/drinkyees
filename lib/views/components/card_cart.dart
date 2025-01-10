import 'package:flutter/material.dart';

class CardCart extends StatelessWidget {
  const CardCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 10.0
      ),
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/drink1.png"),
                fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade50,
                )
              ]
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "Ice Americano With Milk",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Row(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: (){}, 
                            icon: Icon(Icons.minimize, size: 12.0,)
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}