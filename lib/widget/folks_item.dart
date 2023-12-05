import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:folks/utils/folks_color.dart';
import 'package:folks/widget/folk_detail.dart';

// Нэг ширхэг үлгэрийг харуулах
class FolksItem extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> folk;
  const FolksItem({required this.folk, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FolkDetail(folk: folk),
          ),
        );
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: folk.get('image'),
              height: 190,
              width: 190,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            folk.get('Name'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${folk.get('duration')} мин',
            style: TextStyle(
              color: FolksColor.subtitle.withOpacity(0.7),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
