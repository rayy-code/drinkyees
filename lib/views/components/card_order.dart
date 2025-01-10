import 'package:flutter/material.dart';
import 'package:pbm_project1_uas/data/models/cart_model.dart';
import 'package:pbm_project1_uas/helper/format_string.dart';

class CardOrder extends StatelessWidget {
  final String status;
  final String idOrder;
  final List<CartModel> order;
  final int total;

  const CardOrder({
    super.key,
    required this.status,
    required this.idOrder,
    required this.order,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Tambahkan aksi ketika kartu ditekan
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Date : $idOrder',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      color: status == 'selesai' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              // List Produk
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 150.0, // Tentukan tinggi maksimum ListView
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        order[index].strDrink,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/${order[index].strDrinkThumb}',
                            ),
                          ),
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${FormatString.toRupiah(order[index].price)}'),
                          Text('x${order[index].quantity}'),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Footer (Total Harga)
              const SizedBox(height: 10.0),
              Text(
                "Total ${order.length} produk : ${FormatString.toRupiah(total)}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
