import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pbm_project1_uas/helper/format_string.dart';

class CardDrink extends StatelessWidget {
  final String idDrink;
  final String name;
  final double rating;
  final int price;
  final String imgDrink;
  final Function? onTap;
  final Function? onAdd;

  const CardDrink({
    super.key,
    required this.idDrink,
    required this.name,
    required this.rating,
    required this.price,
    required this.imgDrink,
    this.onTap,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        width: 180,
        height: 235,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                //blurRadius: 10,
                //offset: const Offset(0, 3),
                blurStyle: BlurStyle.solid)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Hero(
                  tag: imgDrink,
                  child: Image(
                    //image: NetworkImage(imgDrink, scale: 1.0),
                    image: AssetImage("assets/images/$imgDrink"),
                    height: 80,
                  ),
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.fade),
              ),
              const SizedBox(
                height: 4.0,
              ),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                maxRating: 5,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 12,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                onRatingUpdate: (index) {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    FormatString.toRupiah(price),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      onAdd!();
                    },
                    icon: const Icon(Icons.add, weight: 10.0),
                    iconSize: 20,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
