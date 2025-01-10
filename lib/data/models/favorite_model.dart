class FavoriteModel {
  final String uidUser;
  final String idProduct;
  final String strProduct;
  final String strDescription;
  final int price;
  final double rating;
  final String strProductThumb;

  const FavoriteModel({
    required this.uidUser,
    required this.idProduct,
    required this.strProduct,
    required this.strDescription,
    required this.price,
    required this.rating,
    required this.strProductThumb,
  });

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      uidUser: map['uidUser'],
      idProduct: map['idProduct'],
      strProduct: map['strProduct'],
      strDescription: map['strDescription'],
      price: map['price'],
      rating: map['rating'],
      strProductThumb: map['strProductThumb'],
    );
  }
}
