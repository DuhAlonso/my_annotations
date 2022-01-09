import 'package:my_annotations/model/annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnnotationHelper {
  static final String nameTable = 'annotation';
  static final AnnotationHelper _annotationHelper =
      AnnotationHelper._internal();

  Database? _db; // add late <<<<<

  factory AnnotationHelper() {
    return _annotationHelper;
  }
  AnnotationHelper._internal() {}

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializeDb();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {
    String sql =
        'CREATE TABLE $nameTable (id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR, description TEXT, date DATETIME)';
    await db.execute(sql);
  }

  inicializeDb() async {
    final patchBD = await getDatabasesPath();
    final localeBD = join(patchBD, 'my_anotations.bd');
    var db = await openDatabase(localeBD, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> saveAnnotation(Annotation annotation) async {
    var dataBase = await db;
    int result = await dataBase.insert(nameTable, annotation.toMap());
    return result;
  }

  Future<int> updateAnnotation(Annotation annotation) async {
    var dataBase = await db;
    return await dataBase.update(nameTable, annotation.toMap(),
        where: "id = ?", whereArgs: [annotation.id]);
  }

  listAnnotation() async {
    var dataBase = await db;
    String sql = 'SELECT * FROM $nameTable ORDER BY date DESC';
    List annotations = await dataBase.rawQuery(sql);
    return annotations;
  }
}
