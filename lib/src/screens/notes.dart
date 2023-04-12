import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes/src/bloc/provider.dart';
import 'package:notes/src/models/item_model.dart';
import '../resources/db_provider.dart';
import '../resources/new_db_provider.dart';
import '../widgets/notes_list_tile.dart';

class Notes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NotesState();
}

class NotesState extends State<Notes> {
  Future<List<Map<String, dynamic>>> getNotes() async {
    Future<List<Map<String, dynamic>>> notes =
        await DatabaseProvider.db.getNotes();
    return notes;
  }

  List<Widget> children = [];
  var itemCount;
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return FutureBuilder(
      future: getNotes(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Notes'),
                ),
                body: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                ),
              );
            }
          case ConnectionState.done:
            {
              if (!snapshot.hasData) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Notes'),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/$itemCount");
                    },
                  ),
                  body: const Center(
                      child: Text('You do not have any notes. Create one.')),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, int index) {
                    bloc.fetchItem(index);
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          'Notes ${snapshot.data!.length}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Colors.amber,
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          itemCount = snapshot.data!.length;
                          Navigator.pushNamed(context, "/$itemCount");
                        },
                        child: const Icon(Icons.add),
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      body: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: itemCount,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return NotesListtile(
                                item: snapshot.data!,
                                itemId: index,
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              }
            }
          case ConnectionState.none:
            // TODO: Handle this case.
            break;
          case ConnectionState.active:
            // TODO: Handle this case.
            break;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Notes'),
          ),
          body: const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          ),
        );
      },
    );
  }
}
