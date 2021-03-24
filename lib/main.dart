import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/database/database_adm_connection.dart';
import 'package:todo_app/app/modules/home/home_controller.dart';
import 'package:todo_app/app/modules/home/home_page.dart';
import 'package:todo_app/app/modules/new_task/new_task_page.dart';
import 'package:todo_app/app/modules/new_task/new_task_controller.dart';
import 'package:todo_app/app/repositories/todos_repositorys.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  DatabaseAdmConnection databaseAdmConnection = DatabaseAdmConnection();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(databaseAdmConnection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(databaseAdmConnection);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider(create: (_) => TodosRepository())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(
          primaryColor: Color(0xFFFF9129),
          buttonColor: Color(0xFFFF9129),
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        routes: {
          NewTaskPage.routerName: (_) => ChangeNotifierProvider(
                create: (context) {
                  var newTaskController = NewTaskController(
                    repository: context.read<TodosRepository>(),
                  );
                  return newTaskController;
                },
                child: NewTaskPage(),
              )
        },
        home: ChangeNotifierProvider(
          create: (context) {
            var repository = context.read<TodosRepository>();
            return HomeController(repository: repository);
          },
          child: HomePage(),
        ),
      ),
    );
  }
}
