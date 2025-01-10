import 'package:flutter/material.dart';

Widget bgHome (){
  return Container(
    width: double.infinity,
    height: 300.0,
    decoration: const BoxDecoration(
      color: Colors.tealAccent,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30.0),
        bottomRight: Radius.circular(30.0),
      )
    ),
    
  );
}