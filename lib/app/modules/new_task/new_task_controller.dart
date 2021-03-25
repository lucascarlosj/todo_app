import 'package:flutter/foundation.dart';
import 'package:todo_app/app/repositories/todos_repositorys.dart';

class NewTaskController extends ChangeNotifier {

  final TodosRepository repository;

  NewTaskController({@required this.repository});
}
