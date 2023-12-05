import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:folks/api/api_helper.dart';
import 'package:folks/folks.dart';
import 'package:folks/utils/folks_color.dart';
import 'package:folks/widget/pages/authPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiHelper.init();
  ApiHelper.categories = await ApiHelper.getCategories();

  ApiHelper.folks = await ApiHelper.getSuggestedFolks()
      as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
  log('folks ${ApiHelper.folks}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Folks app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(backgroundColor: FolksColor.background),
        primaryColor: FolksColor.primary,
        colorScheme:
            ColorScheme.fromSeed(seedColor: FolksColor.primary).copyWith(
          background: FolksColor.background,
        ),
      ),
      home: const AuthPage(),
    );
  }
}
