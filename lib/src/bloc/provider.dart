import 'package:flutter/material.dart';
import 'bloc.dart';
export 'bloc.dart';

class Provider extends InheritedWidget {
  final bloc = Bloc();

  Provider({Key? key, child}) : super(key: key, child: child);

  static Bloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider)
        .bloc;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
