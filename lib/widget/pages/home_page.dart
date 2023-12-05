import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folks/widget/category_item_folks.dart';
import 'package:folks/widget/suggested_folks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Нүүр хуудасны ui
class HomePage extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> categories;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> suggestedFolks;
  HomePage({
    required this.categories,
    required this.suggestedFolks,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SuggestedFolks(suggestedFolks: suggestedFolks),
          for (int i = 0; i < categories.length; i++)
            CateroryItemFolks(
              categoryId: categories[i].id,
              categoryName: categories[i].get('name'),
            ),
        ],
      ),
    );
  }
}
