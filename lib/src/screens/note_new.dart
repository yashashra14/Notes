import 'package:flutter/material.dart';
import '../resources/new_db_provider.dart';

class NotesNew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StateNotesNew();
}

class StateNotesNew extends State<NotesNew> {
  Future<List<Map<String, dynamic>>?> getNotes() async {
    Future<List<Map<String, dynamic>>> notes =
        await DatabaseProvider.db.getNotes();
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Notes"),
      ),
      body: FutureBuilder(
        future: getNotes(),
        builder:
            (context, AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            case ConnectionState.done:
              {
                if (snapshot.data == Null) {
                  return Center(
                    child: Text("You dont have any notes yet, create one"),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.builder(
                      itemCount: snapshot.hasData ? snapshot.data?.length : 0,
                      itemBuilder: (context, index) {
                        String title = snapshot.data![index]['title'];
                        String body = snapshot.data![index]['body'];
                        int id = snapshot.data![index]['id'];
                        return Card(
                          child: ListTile(
                            title: Text(title),
                            subtitle: Text(body),
                          ),
                        );
                      },
                    ),
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
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
