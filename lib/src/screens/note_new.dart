import 'package:flutter/material.dart';
import 'package:notes/src/models/item_model.dart';
import '../resources/new_db_provider.dart';

class NotesNew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StateNotesNew();
}

class StateNotesNew extends State<NotesNew> {
  Future<List<Map<String, Object?>>> getNotes() async {
    List<Map<String, Object?>> notes = await DatabaseProvider.db.getNotes();
    return notes;
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/${count + 1}');
        },
      ),
      body: FutureBuilder(
        future: getNotes(),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            case ConnectionState.done:
              {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("You dont have any notes yet, create one"),
                  );
                }
                count = snapshot.hasData ? snapshot.data!.length : 0;
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: snapshot.hasData ? snapshot.data?.length : 0,
                    itemBuilder: (context, index) {
                      String title = snapshot.data![index]['title'] as String;
                      String body = snapshot.data![index]['body'] as String;
                      int id = snapshot.data![index]['id'] as int;
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, "/$id");
                          },
                          title: Text(title),
                          subtitle: Text(body),
                        ),
                      );
                    },
                  ),
                );
              }
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
