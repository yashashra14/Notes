import 'package:flutter/material.dart';

class NotesListtile extends StatelessWidget {
  List<Map<String, dynamic>> item;
  int itemId;
  NotesListtile({required this.item, required this.itemId});
  @override
  Widget build(BuildContext context) {
    String title = item[itemId]['title'];
    String subtitle = item[itemId]['body'];
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
