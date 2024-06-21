import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/color.dart';
import '../../components/product_card.dart';

class ProductList extends StatefulWidget {
  @override
  State<ProductList> createState() => _ProductListState();

  ProductList({super.key, required this.isNav});
  bool isNav;
}

class _ProductListState extends State<ProductList> {
  late ScrollController scrollController;
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        backgroundColor: const Color(0xffbfe0f8),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: widget.isNav ? const Color(0xffbfe0f8) : Theme.of(context).scaffoldBackgroundColor,
                pinned: true,
                title: getAppBar(),
                leading: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu, color: Colors.black),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  var documents = snapshot.data!.docs;
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var document = documents[index];
                        return ProductCard(
                          title: document['name'],
                          price: document['price'],
                          oldPrice: document['oldPrice'],
                          ratings: document['ratings'],
                          imageUrl: document['imageUrl'],
                          productUrl: document['amazonLink'],
                        );
                      },
                      childCount: documents.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAppBar() {
    return const Row(
      children: [
        Text(
          'Products',
          style: TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 24),
        ),
      ],
    );
  }
}
