import 'package:flutter/material.dart';
import 'package:pbm_project1_uas/data/models/cart_model.dart';
import 'package:pbm_project1_uas/helper/format_string.dart';

class PaymentTransfer extends StatefulWidget {
  final int totalPrice;

  final List<CartModel> data;

  const PaymentTransfer(
      {super.key, required this.totalPrice, required this.data});

  @override
  State<PaymentTransfer> createState() => _PaymentTransferState();
}

class _PaymentTransferState extends State<PaymentTransfer> {
  final Text namaPT = const Text(
    "PT. DRINKYEES INDONESIA",
    style: TextStyle(
        color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "1523357530",
                style: TextStyle(
                    color: Color.fromARGB(255, 44, 0, 241),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Text("PT. DRINKYEES INDONESIA",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold)),
              Text("Bank BNI",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),

        const SizedBox(
          height: 20,
        ),
        widget.data.isNotEmpty
            ? ListView.builder(
                itemCount: widget.data.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Card(
                      child: ListTile(
                        tileColor: Colors.white,
                        leading: Container(
                          width: 30,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    "assets/images/${widget.data[index].strDrinkThumb}"),
                                scale: 1.0),
                          ),
                        ),
                        title: Text(
                          widget.data[index].strDrink,
                        ),
                        subtitle: Text("(${widget.data[index].quantity})"),
                        trailing: Text(
                          FormatString.toRupiah(widget.data[index].totalPrice),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ))
            : Center(
                child: Text("Data tidak ada"),
              )
        // Container(
        //     decoration: const BoxDecoration(
        //         color: Colors.white60,
        //         borderRadius: BorderRadius.all(Radius.circular(10.0))),
        //     height: 200,
        //     width: MediaQuery.of(context).size.width,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         const Center(
        //           child: Text("Alur Pembayaran Melalui Transfer Bank",
        //               style: TextStyle(
        //                   fontSize: 16,
        //                   color: Colors.black54,
        //                   fontWeight: FontWeight.bold)),
        //         ),
        //         const SizedBox(
        //           height: 20,
        //         ),
        //         Text("1. Salin nomor rekening bank ${namaPT.data}",
        //             style: const TextStyle(
        //                 fontSize: 12,
        //                 color: Colors.black,
        //                 overflow: TextOverflow.fade))
        //       ],
        //     )),
      ],
    );
  }
}
