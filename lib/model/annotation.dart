class Annotation {
  int? id;
  String? title;
  String? description;
  String? date;

  Annotation(
    this.title,
    this.description,
    this.date,
  );

  Map toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'description': description,
      'date': date,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Annotation.fromMap(Map map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    date = map['date'];
  }
}
