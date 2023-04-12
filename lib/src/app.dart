import 'package:flutter/material.dart';
import 'package:notes/src/models/item_model.dart';
import 'package:notes/src/screens/note_detail.dart';
import 'bloc/provider.dart';
import 'screens/notes.dart';
import 'resources/db_provider.dart';
import 'screens/note_new.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'ToDos',
        onGenerateRoute: (RouteSettings settings) {
          return routes(settings);
        },
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          return NotesNew();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final itemId = int.parse(settings.name!.replaceFirst('/', ''));
          return NotesDetail(
            itemId: itemId,
          );
        },
      );
    }
  }
}
