import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folks/api/api_helper.dart';
import 'package:folks/utils/folks_color.dart';
import 'package:folks/widget/category_folks.dart';
import 'package:folks/widget/pages/home_page.dart';

import '../category_item_folks.dart';
import '../folks_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> categories = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> suggestedFolks = [];
  int currentIndex = 0;
  String searchKey = '';

  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchSuggestedFolks();
    searchController = TextEditingController();
  }

  void fetchCategories() async {
    final data = await ApiHelper.getCategories();
    setState(() {
      categories = data;
    });
  }

  void fetchSuggestedFolks() async {
    final data = await ApiHelper.getSuggestedFolks();
    setState(() {
      suggestedFolks = data;
    });
  }

  void setCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget getBodyView() {
    return HomePage(categories: categories, suggestedFolks: suggestedFolks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: (query) async {
            setState(() {
              searchKey = query;
            });
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Хайх',
            hintStyle: TextStyle(color: Colors.white),
            filled: true,
            fillColor: FolksColor.secondBackground,
            suffixIcon: Icon(Icons.search, color: FolksColor.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.white),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          ),
        ),
      ),
      body: DefaultTabController(
        length: categories.length,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              dividerHeight: 0,
              padding: const EdgeInsets.all(20),
              physics: const ClampingScrollPhysics(),
              indicatorPadding: EdgeInsets.zero,
              indicatorWeight: 6,
              indicatorColor: FolksColor.secondBackground,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                for (var category in categories)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      category.get('name'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  for (var category in categories)
                    CategoryFolks(categoryId: category.id, search: searchKey)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
