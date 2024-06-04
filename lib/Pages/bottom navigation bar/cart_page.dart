import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // body: _buildUserList(),
      backgroundColor: Color(0xffbfe0f8),
      body: Center(
        child: Text("Cart Screen"),
      ),
    );
  }
}
