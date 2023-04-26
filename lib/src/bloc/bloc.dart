import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../resources/db_provider.dart';
import '../models/item_model.dart';

class Bloc {
  final dbProvider = DbProvider();
  final _title = StreamController<String>.broadcast();
  final _content = StreamController<String>.broadcast();

  final _topIds = PublishSubject<int>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel?>>>();
  final _itemsFetcher = PublishSubject<int>();

  Bloc() {
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  Stream<Map<int, Future<ItemModel?>>> get items => _itemsOutput.stream;
  Stream<int> get topIds => _topIds.stream;
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  void fetchTopIds() async {
    final ids = await dbProvider.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache() {
    return dbProvider.clear();
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel?>> cache, int id, _) {
        cache[id] = dbProvider.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel?>>{},
    );
  }

  //change data
  Function(String) get changeTitle => _title.sink.add;
  Function(String) get changeContent => _content.sink.add;

  // add data to stream
  Stream<String> get title => _title.stream;
  Stream<String> get content => _content.stream;

  dispose() {
    _title.close();
    _content.close();
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
