import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:folks/api/api_helper.dart';
import 'package:folks/widget/folks_item.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<DocumentSnapshot<Map<String, dynamic>>> likedFolks = [];

  void fetchItems() async {
    final result = await ApiHelper.getLikedFolks();
    setState(() {
      likedFolks = result;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      fetchItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.55,
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 0.0,
        ),
        padding: const EdgeInsets.all(20),
        itemCount: likedFolks.length,
        itemBuilder: (context, index) {
          return FolksItem(folk: likedFolks[index]);
        },
      ),
    );
  }
}
