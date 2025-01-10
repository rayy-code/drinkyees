import 'package:flutter/material.dart';

class CardMenu2 extends StatelessWidget {

  final String title;
  final String subTitle;
  final Widget trailing;
  final String image;

  const CardMenu2({
    super.key,
    required this.title,
    required this.subTitle,
    required this.trailing,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 150,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image, scale: 1.0),
                fit: BoxFit.cover
              )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis
                ),
              ),
              trailing
            ]
          ),
          Text(
            subTitle,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ]
      ),
    );
  }
}