import 'package:flutter/material.dart';

Widget cardMenu (String imgLink, int price)
{
  return Card(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[

          //image
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              image: const DecorationImage(
                
                image: NetworkImage("https://www.tasteofhome.com/wp-content/uploads/2024/05/Sweet-Rum-Punch_EXPS_FT24_273648_EC_050224_4.jpg",scale: 1.0),
                fit: BoxFit.cover,
              )
            ),
          ),
          const SizedBox(height: 5),

          //text
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   mainAxisSize: MainAxisSize.max,
          //   children: <Widget>[
              
              
          //   ]
          // )
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              const Flex(
                direction: Axis.vertical,
                children: [
                  Text("Nama Minuman", style: TextStyle(fontSize: 9.0),),
                  Text("Nama Minuman", style: TextStyle(fontSize: 9.0),),
                ],
              ),
              IconButton(
                onPressed: (){

                },
                icon: const Icon(Icons.plus_one),
              )
            ]
          )
        ]
      )
    ),
  );
}