import 'package:flutter/material.dart';

Widget bgDetailDrink ()
{
  return Container(
    width: double.infinity,
    height: 300,
    decoration: const BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(5.0),
        bottomRight: Radius.circular(5.0),
      )
    )
  );
}