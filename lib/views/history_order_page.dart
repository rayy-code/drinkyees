import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pbm_project1_uas/data/firebase/order_collection.dart';
import 'package:pbm_project1_uas/data/models/order_model.dart';
import 'package:pbm_project1_uas/views/orders_proses.page.dart';
import 'package:pbm_project1_uas/views/orders_selesai.dart';

class HistoryOrderPage extends StatefulWidget {
  final int total;
  const HistoryOrderPage({super.key, required this.total});

  @override
  State<HistoryOrderPage> createState() => _HistoryOrderPageState();
}

class _HistoryOrderPageState extends State<HistoryOrderPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final _auth = FirebaseAuth.instance.currentUser;
  List<OrderModel> dataOrder = [];
  List<OrderModel> dataOrder2 = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    getOrder();
    getCompleteOrder();
    //getOrder("pending");
  }

  //mengambil order berdasarkan status dan user
  Future<void> getOrder() async {
    // TODO: implement getOrder
    List<OrderModel> temp =
        await OrderCollection.getOrder(_auth!.uid, "pending");
    setState(() {
      dataOrder = temp;
    });
  }

  //mengambil order berdasarkan status yang sudah selsai dan user
  Future<void> getCompleteOrder() async {
    // TODO: implement getOrder
    List<OrderModel> temp =
        await OrderCollection.getOrder(_auth!.uid, "selesai");
    setState(() {
      dataOrder2 = temp;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            child: TabBar(
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              controller: _tabController,
              tabs: const [
                Tab(child: Text("Proses")),
                Tab(child: Text("Selesai")),
                Tab(child: Text("Semua")),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1
                _auth != null
                    ? OrderProsessPage(total: widget.total, data: dataOrder)
                    : Center(
                        child: Text("Something wrong"),
                      ),
                // Tab 2
                _auth != null
                    ? OrdersSelesai(data: dataOrder2)
                    : Center(
                        child: Text("Anda belum lgin"),
                      ),
                Center(child: Text("Anda belum login")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
