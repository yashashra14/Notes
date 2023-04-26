import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../resources/new_db_provider.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StateNotesNew();
}

class StateNotesNew extends State<Notes> {
  Future<List<Map<String, Object?>>> getNotes() async {
    List<Map<String, Object?>> notes = await DatabaseProvider.db.getNotes();
    return notes;
  }
  Future<void> deleteItem(int itemId) async {
    DatabaseProvider.db.deleteItem(itemId);
  }


  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        title: const Text("Your Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/${count+ 1}');
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
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.hasData ? snapshot.data?.length : 0,
                    itemBuilder: (context, index) {
                      int reverseIndex = snapshot.data!.length - 1 - index;
                      String title =
                          snapshot.data![reverseIndex]['title'] as String;
                      String body =
                          snapshot.data![reverseIndex]['body'] as String;
                      int id = snapshot.data![reverseIndex]['id'] as int;
                      return Card(
                        color: Colors.amber[100],
                        child: ListTile(
                          visualDensity: const VisualDensity(
                            horizontal: 0,
                            vertical: 4,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, "/$id");
                          },
                          title: Text(
                            title,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            body,
                            maxLines: 4,
                          ),
                          // trailing: IconButton(
                          //   icon: const Icon(Icons.cancel),
                          //   onPressed: () {
                          //     setState(() {
                          //       deleteItem(id);
                          //     });
                          //   },
                          // ),
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
