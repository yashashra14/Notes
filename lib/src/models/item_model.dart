class ItemModel {
  final int? id;
  final String? title;
  final String? subtile;
  ItemModel.fromDb(Map<String, dynamic> parsedDb)
      : id = parsedDb['id'],
        title = parsedDb['title'],
        subtile = parsedDb['subtitle'];

  ItemModel({this.id, this.title, this.subtile});

  Map<String, dynamic> toMap() {
    return (<String, dynamic>{
      "id": id,
      "title": title,
      "subtitle": subtile,
    });
  }
}
