import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/app/repositories/todos_repositorys.dart';

class NewTaskController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TodosRepository repository;
  final dateFormat = DateFormat('dd/MM/yyyy');
  DateTime daySelected;
  TextEditingController nomeTaskController = TextEditingController();
  bool saved = false;
  bool loading = false;
  String error;

  String get dayFormated => dateFormat.format(daySelected);

  NewTaskController({this.repository, String day}) {
    daySelected = dateFormat.parse(day);
  }

  Future<void> save() async {
    try {
      if (formKey.currentState.validate()) {
        loading = true;
        saved = false;
        await repository.saveTodo(daySelected, nomeTaskController.text);
        loading = false;
        saved = true;
      }
    } catch (e) {
      print(e);
      error = 'Erro ao salvar Todo';
    }
    notifyListeners();
  }
}
