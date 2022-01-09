import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_annotations/helper/annotation_helper.dart';
import 'package:my_annotations/model/annotation.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _db = AnnotationHelper();
  List<Annotation> annotations = [];

  _showAnnotationData({Annotation? annotation}) {
    String saveUpdateText = '';
    if (annotation == null) {
      _nameController.clear();
      _descriptionController.clear();
      saveUpdateText = 'Salvar';
    } else {
      saveUpdateText = 'Atualizar';
      _nameController.text = annotation.title!;
      _descriptionController.text = annotation.description!;
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$saveUpdateText Anotação'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  autofocus: true,
                  controller: _nameController,
                  decoration: const InputDecoration(
                    label: Text(
                      'Nome da Anotação',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                TextFormField(
                  autofocus: true,
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    label: Text(
                      'Anotação',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: const Size(100, 40),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: const Size(100, 40),
                ),
                onPressed: () {
                  _saveUpdateAnnotation(annotationActual: annotation);
                  _nameController.clear();
                  _descriptionController.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  saveUpdateText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              )
            ],
          );
        });
  }

  _saveUpdateAnnotation({Annotation? annotationActual}) async {
    String title = _nameController.text;
    String description = _descriptionController.text;
    if (annotationActual == null) {
      String date = DateTime.now().toString();
      Annotation annotation = Annotation(title, description, date);
      await _db.saveAnnotation(annotation);
    } else {
      annotationActual.title = title;
      annotationActual.description = description;
      await _db.updateAnnotation(annotationActual);
    }
    _listAnnotations();
  }

  _listAnnotations() async {
    List annotationsDb = await _db.listAnnotation();

    List<Annotation> annotationsTemp = [];
    for (var item in annotationsDb) {
      Annotation annotation = Annotation.fromMap(item);
      annotationsTemp.add(annotation);
    }
    setState(() {
      annotations = annotationsTemp;
    });
    annotationsTemp = [];
  }

  formatDate(String date) {
    initializeDateFormatting('pt_BR');
    var formatterDay = DateFormat('dd');
    var formatterMonth =
        DateFormat.MMM('pt_BR'); // formata no padrão Brasileiro
    DateTime dateConvertedDay = DateTime.parse(date);
    DateTime dateConvertedMonth = DateTime.parse(date);
    String formattedDateDay = formatterDay.format(dateConvertedDay);
    String formattedDateMonth = formatterMonth.format(dateConvertedMonth);
    return Text(
      '$formattedDateDay' '\n' '${formattedDateMonth.toUpperCase()}',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  _deleteAnnotation(int id) async {
    _db.deleteAnnotation(id);
    _listAnnotations();
  }

  @override
  void initState() {
    _listAnnotations();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Anotações'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: annotations.length,
              itemBuilder: (context, index) {
                final annotation = annotations[index];
                return Card(
                  child: ListTile(
                    leading: formatDate(annotation.date!),
                    title: Text(annotation.title!),
                    subtitle: Text(annotation.description!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          child: const Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                          onTap: () {
                            _showAnnotationData(annotation: annotation);
                          },
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onTap: () {
                            _deleteAnnotation(annotation.id!);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAnnotationData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
