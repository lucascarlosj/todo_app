import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/modules/new_task/new_task_controller.dart';

class NewTaskPage extends StatelessWidget {
  const NewTaskPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Consumer<NewTaskController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Nova Task'),           
          ),
          body: Container(
            child: Center(
              child: Text(''),
            ),
          ),
        );
      },
    ));
  }
}