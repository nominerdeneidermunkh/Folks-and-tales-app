import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:folks/utils/folks_color.dart';
import 'package:folks/widget/pages/playing.dart';

class FolkDetail extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> folk;

  const FolkDetail({required this.folk, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CachedNetworkImage(
                  imageUrl: folk.get('image'),
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                folk.get('Name'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category, size: 20, color: Colors.blue),
                  SizedBox(width: 5),
                  FutureBuilder(
                    future: getCategoryName(folk.get('category_id')),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error loading category');
                      } else {
                        return Text(
                          snapshot.data.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: FolksColor.subtitle.withOpacity(0.7),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.access_time, size: 20, color: Colors.blue),
                  SizedBox(width: 5),
                  Text(
                    '${folk.get('duration')} мин',
                    style: TextStyle(
                      color: FolksColor.subtitle.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  folk.get('description'),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff8F8F8F),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayingView(
                        folk: folk,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: FolksColor.background,
                  side: BorderSide(
                    color: Color(0xFF192ABE),
                    width: 2.0,
                  ),
                ),
                child: Text(
                  'Сонсох',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getCategoryName(String categoryId) async {
    try {
      DocumentSnapshot categorySnapshot = await FirebaseFirestore.instance
          .collection("Folks' category")
          .doc(categoryId)
          .get();
      return categorySnapshot.get('name');
    } catch (e) {
      return 'Category not found';
    }
  }
}
