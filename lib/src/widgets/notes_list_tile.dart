import 'package:flutter/material.dart';
import 'package:notes/src/bloc/provider.dart';
import '../models/item_model.dart';
import '../resources/db_provider.dart';
import '../resources/new_db_provider.dart';

class NotesListtile extends StatelessWidget {
  List<Map<String, dynamic>> item;
  int itemId;
  NotesListtile({required this.item, required this.itemId});
  @override
  Widget build(BuildContext context) {
    String title = item[itemId]['title'];
    String subtitle = item[itemId]['id'];
    return ListTile(
      title: Text(title),
      subtitle: Text(item[itemId]['body']),
    );
  }
}
