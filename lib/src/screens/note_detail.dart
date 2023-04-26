import 'dart:async';
import 'package:flutter/material.dart';
import '../bloc/provider.dart';
import '../resources/new_db_provider.dart';
import '../models/item_model.dart';

// ignore: must_be_immutable
class NotesDetail extends StatelessWidget {
  void addNote(ItemModel itemModel) async {
    await DatabaseProvider.db.addNewNote(itemModel);
  }

  void editNote(ItemModel itemModel) async {
    await DatabaseProvider.db.editItem(itemModel);
  }

  Future<List<Map<String, Object?>>> getNotes() async {
    List<Map<String, Object?>> notes = await DatabaseProvider.db.getNotes();
    return notes;
  }

  Future<ItemModel?> getItem(int id) async {
    ItemModel? itemModel = await DatabaseProvider.db.fetchItem(id);
    return itemModel;
  }

  final int? itemId;
  String title = '';
  String content = '';

  NotesDetail({Key? key, this.itemId}) : super(key: key);

  TextEditingController titleEditingController = TextEditingController();
  TextEditingController contentEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    // StreamSubscription<String> titleStream = bloc.title.listen((event) {
    //   title = event;
    // });
    // StreamSubscription<String> contentStream = bloc.content.listen((event) {
    //   content = event;
    // });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
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
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: getItem(itemId!),
        builder: (context, AsyncSnapshot<ItemModel?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              {
                return Container(
                  margin: const EdgeInsets.all(16),
                  child: Expanded(
                    child: Column(
                      children: [
                        titleField(bloc),
                        contentField(bloc),
                      ],
                    ),
                  ),
                );
              }
            case ConnectionState.none:
              {
                return const Center(child: Text("None"));
              }
            case ConnectionState.active:
              {
                return const Center(child: Text("Active"));
              }
            case ConnectionState.done:
              {
                return Container(
                  margin: const EdgeInsets.all(16),
                  child: Expanded(
                    child: Column(
                      children: [
                        titleField(bloc, title: snapshot.data?.title),
                        contentField(bloc, content: snapshot.data?.subtile),
                      ],
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget titleField(Bloc bloc, {String? title}) {
    titleEditingController.text = title ?? "";
    titleEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: titleEditingController.text.length));
    return StreamBuilder(
      stream: bloc.title,
      builder: (context, snapshot) {
        return TextField(
          controller: titleEditingController,
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

  Widget contentField(Bloc bloc, {String? content}) {
    contentEditingController.text = content ?? "";
    contentEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: contentEditingController.text.length));
    return StreamBuilder(
      stream: bloc.content,
      builder: (context, snapshot) {
        return Expanded(
          child: TextField(
            autofocus: true,
            controller: contentEditingController,
            maxLines: 999999999,
            keyboardType: TextInputType.multiline,
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
    title = titleEditingController.text.trim();
    content = contentEditingController.text.trim();
    if (title.isNotEmpty || content.isNotEmpty) {
      final ItemModel item = ItemModel(
        id: itemId,
        title: title,
        subtile: content,
      );
      editNote(item);
    }
    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
  }
}
