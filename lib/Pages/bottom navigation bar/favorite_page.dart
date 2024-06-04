import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // body: _buildUserList(),
      backgroundColor: Color(0xffbfe0f8),
      body: Center(
        child: Text("Favorite Screen"),
      ),
    );
  }
}
