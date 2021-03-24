import 'package:flutter/cupertino.dart';
import 'package:todo_app/app/repositories/todos_repositorys.dart';

class HomeController extends ChangeNotifier{

  int selectedTab = 1;
  final TodosRepository repository;
  HomeController({@required this.repository});


  void changeSelectedTab(index){
    selectedTab = index;
    notifyListeners();
  }
  
}