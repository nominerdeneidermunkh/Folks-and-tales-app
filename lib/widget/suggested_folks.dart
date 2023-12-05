import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folks/widget/folks_item.dart';

class SuggestedFolks extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> suggestedFolks;
  const SuggestedFolks({required this.suggestedFolks, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 28),
          child: Text(
            'Санал болгож буй',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 255,
          child: ListView.separated(
            itemCount: suggestedFolks.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 28, right: 28),
            itemBuilder: (context, index) {
              return FolksItem(folk: suggestedFolks[index]);
            },
            separatorBuilder: (context, index) => const SizedBox(width: 20),
          ),
        ),
      ],
    );
  }
}
