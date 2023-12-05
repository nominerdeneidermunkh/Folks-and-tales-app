import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folks/api/api_helper.dart';
import 'package:folks/utils/folks_color.dart';
import 'package:folks/widget/pages/authPage.dart';
import 'package:folks/widget/pages/favorite_page.dart';
import 'package:folks/widget/pages/home_page.dart';
import 'package:folks/widget/pages/profile_page.dart';
import 'package:folks/widget/pages/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Folks extends StatefulWidget {
  const Folks({Key? key}) : super(key: key);

  @override
  State<Folks> createState() => _FolksState();
}

class _FolksState extends State<Folks> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> categories = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> suggestedFolks = [];
  int currentIndex = 0;

  @override
  void initState() {
    fetchCategories();
    fetchSuggestedFolks();
    super.initState();
  }

  // ApiHelper ээс категори авах
  void fetchCategories() async {
    final data = await ApiHelper.getCategories();
    setState(() {
      categories = data;
    });
  }

  // ApiHelper ээс санал болгосон үлгэрүүдийг авах
  void fetchSuggestedFolks() async {
    final data = await ApiHelper.getSuggestedFolks();
    setState(() {
      suggestedFolks = data;
    });
  }

  // 4 Хуудас солих үйлдэл
  void setCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // 4 хуудсан тохирох UI-г буцаах,s өгөх
  Widget getBodyView() {
    switch (currentIndex) {
      case 0:
        return HomePage(categories: categories, suggestedFolks: suggestedFolks);
      case 1:
        return SearchPage();
      case 2:
        return const FavoritePage();
      case 3:
        return ProfileScreen();

      default:
        return HomePage(categories: categories, suggestedFolks: suggestedFolks);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: getBodyView(),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  // Доод талын 4 menu
  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: FolksColor.secondary,
      unselectedItemColor: FolksColor.primary,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      onTap: (value) {
        setCurrentIndex(value);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'favorite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'person',
        ),
      ],
    );
  }
}
