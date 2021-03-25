import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/app/models/todo_model.dart';
import 'package:todo_app/app/repositories/todos_repositorys.dart';
import 'package:collection/collection.dart';

class HomeController extends ChangeNotifier {
  int selectedTab = 1;
  var dateFormart = DateFormat('dd/MM/yyyy');
  DateTime daySelected;
  DateTime startFilter;
  DateTime endFilter;
  Map<String, List<TodoModel>> listTodos;

  final TodosRepository repository;
  HomeController({@required this.repository}) {
    findAllForWeek();
  }

  Future<void> findAllForWeek() async {
    daySelected = DateTime.now();
    startFilter = DateTime.now();

    if (startFilter.weekday != DateTime.monday) {
      startFilter =
          startFilter.subtract(Duration(days: startFilter.weekday - 1));
    }
    endFilter = startFilter.add(Duration(days: 6));

    var todos = await repository.findByPeriod(startFilter, endFilter);

    if (todos.isEmpty) {
      listTodos = {dateFormart.format(DateTime.now()): []};
    } else {
      listTodos =
          groupBy(todos, (TodoModel todo) => dateFormart.format(todo.dataHora));
    }
    this.notifyListeners();
  }

  Future<void> changeSelectedTab(BuildContext context, index) async {
    selectedTab = index;
    switch (index) {
      case 0:
        filterFinalized();
        break;
      case 1:
        findAllForWeek();
        break;
      case 2:
        var day = await showDatePicker(
          context: context,
          initialDate: daySelected,
          firstDate: DateTime.now().subtract(
            Duration(
              days: (360*3),
            ),
          ),
          lastDate: DateTime.now().add(
            Duration(
              days: (360*10),
            ),
          ),
        );
        if(day != null){
          daySelected = day;
          findTodosBySelectedDays();
        }
        
        break;
    }
    notifyListeners();
  }

  void checkOrUncheck(TodoModel todo) {
    todo.finalizado = !todo.finalizado;
    this.notifyListeners();
    repository.checkOrUncheckTodo(todo);
  }

  void deleteTask(TodoModel todo) {
    //todo.id = !todo.finalizado;
    this.notifyListeners();
    repository.deleteTask(todo);
  }

  void filterFinalized() {
    listTodos = listTodos.map((key, value) {
      var todosFinalized = value.where((t) => t.finalizado).toList();
      return MapEntry(key, todosFinalized);
    });
    this.notifyListeners();
  }

  Future<void> findTodosBySelectedDays() async {
    var todos = await repository.findByPeriod(daySelected, daySelected);

    if (todos.isEmpty) {
      listTodos = {dateFormart.format(daySelected): []};
    } else {
      listTodos =
          groupBy(todos, (TodoModel todo) => dateFormart.format(todo.dataHora));
    }
    this.notifyListeners();

  }

  void update() {
    if(selectedTab == 1){
      this.findAllForWeek();
    } else if(selectedTab == 2){
      this.findTodosBySelectedDays();
    }
  }
}
