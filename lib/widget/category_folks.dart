import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folks/api/api_helper.dart';
import 'package:folks/widget/folks_item.dart';

class CategoryFolks extends StatefulWidget {
  final String? search;
  final String categoryId;
  const CategoryFolks({
    required this.categoryId,
    this.search,
    super.key,
  });

  @override
  State<CategoryFolks> createState() => _CategoryFolksState();
}

class _CategoryFolksState extends State<CategoryFolks> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> folks = [];

  @override
  void initState() {
    fetchFolks();
    super.initState();
  }

  void fetchFolks() async {
    final data = await ApiHelper.getFolks(categoryId: widget.categoryId);
    setState(() {
      folks = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> searchedFolks;

    if (widget.search != null) {
      searchedFolks = folks
          .where((e) => e
              .get('Name')
              .toString()
              .toLowerCase()
              .contains(widget.search!.toLowerCase()))
          .toList();
    } else {
      searchedFolks = folks;
    }

    if (searchedFolks.isEmpty) {
      return const Center(
        child: Text(
          'Өгөгдөл олдсонгүй',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.55,
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 0.0,
      ),
      padding: const EdgeInsets.all(20),
      itemCount: searchedFolks.length,
      itemBuilder: (context, index) {
        return FolksItem(folk: searchedFolks[index]);
      },
    );
  }
}
