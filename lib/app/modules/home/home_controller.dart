import 'package:flutter/cupertino.dart';
import 'package:todo_app/app/repositories/todos_repositorys.dart';

class HomeController extends ChangeNotifier{


  final TodosRepository repository;
  HomeController({@required this.repository});

  
}