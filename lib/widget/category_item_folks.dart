import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folks/api/api_helper.dart';
import 'package:folks/widget/folks_item.dart';

class CateroryItemFolks extends StatefulWidget {
  final String? search;
  final String categoryId;
  final String categoryName;
  const CateroryItemFolks({
    required this.categoryId,
    required this.categoryName,
    this.search,
    super.key,
  });

  @override
  State<CateroryItemFolks> createState() => _CateroryItemFolksState();
}

class _CateroryItemFolksState extends State<CateroryItemFolks> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            '${widget.categoryName} үлгэрүүд',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 255,
          child: searchedFolks.isEmpty
              ? const Center(
                  child: Text(
                    'Өгөгдөл олдсонгүй',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  itemCount: searchedFolks.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 28, right: 28),
                  itemBuilder: (context, index) {
                    return FolksItem(folk: searchedFolks[index]);
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 20),
                ),
        ),
      ],
    );
  }
}
