import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/modules/home/home_controller.dart';

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
        builder: (BuildContext context, HomeController controller, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Atividades'),
        ),
        body: Center(
          child: Container(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/new'),
              child: Text('Clique'),
            ),
          ),
        ),
      );
    });
  }
}
