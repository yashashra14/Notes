import 'dart:async';
import 'package:flutter/material.dart';
import '../bloc/provider.dart';
import '../resources/new_db_provider.dart';
import '../models/item_model.dart';

class NotesDetail extends StatelessWidget {
  addNote(ItemModel itemModel) {
    DatabaseProvider.db.addNewNote(itemModel);
    print("note added successfully");
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    Future<List<Map<String, dynamic>>> notes =
        await DatabaseProvider.db.getNotes();
    return notes;
  }

  final int? itemId;
  String title = '';
  String content = '';
  NotesDetail({this.itemId});
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    StreamSubscription<String> titleStream = bloc.title.listen((event) {
      title = event;
    });
    StreamSubscription<String> contentStream = bloc.content.listen((event) {
      title = event;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('${itemId}'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
              padding: const EdgeInsets.only(right: 16),
              onPressed: () {
                onConfirmTapped(bloc, context);
              },
              icon: const Icon(
                Icons.check,
              ))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Expanded(
          child: Column(
            children: [
              titleField(bloc),
              contentField(bloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleField(bloc) {
    return StreamBuilder(
      stream: bloc.title,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeTitle,
          decoration: const InputDecoration(
            hintText: 'Title',
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.amber,
              ),
            ),
            border: InputBorder.none,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.amber,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget contentField(bloc) {
    return StreamBuilder(
      stream: bloc.content,
      builder: (context, snapshot) {
        return Expanded(
          child: TextField(
            maxLines: 999999999,
            keyboardType: TextInputType.multiline,
            autofocus: true,
            scrollPadding: const EdgeInsets.all(16),
            onChanged: bloc.changeContent,
            decoration: const InputDecoration(
              hintText: 'Start typing',
              border: InputBorder.none,
            ),
          ),
        );
      },
    );
  }

  onConfirmTapped(Bloc bloc, BuildContext context) {
    final ItemModel item = ItemModel(
      id: itemId,
      title: title,
      subtile: content,
    );
    print(item.title);
    addNote(item);
    getNotes();
    Navigator.pop(context);
  }
}
