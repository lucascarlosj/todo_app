import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/modules/home/home_controller.dart';
import 'package:todo_app/app/modules/new_task/new_task_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, HomeController controller, _) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              'Atividades',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          bottomNavigationBar: FFNavigationBar(
            selectedIndex: controller.selectedTab,
            theme: FFNavigationBarTheme(
              itemWidth: 60,
              barHeight: 70,
              barBackgroundColor: Theme.of(context).primaryColor,
              unselectedItemIconColor: Colors.white,
              unselectedItemLabelColor: Colors.white,
              selectedItemBorderColor: Colors.white,
              selectedItemIconColor: Colors.white,
              selectedItemBackgroundColor: Theme.of(context).primaryColor,
              selectedItemLabelColor: Colors.black,
            ),
            onSelectTab: (index) =>
                controller.changeSelectedTab(context, index),
            items: [
              FFNavigationBarItem(
                iconData: Icons.check_circle,
                label: 'Finalizados',
              ),
              FFNavigationBarItem(
                iconData: Icons.view_week,
                label: 'Semanal',
              ),
              FFNavigationBarItem(
                iconData: Icons.calendar_today,
                label: 'Selecionar Data',
              ),
            ],
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: controller.listTodos?.keys?.length ?? 0,
              itemBuilder: (_, index) {
                var dateFormart = DateFormat('dd/MM/yyyy');
                var listTodos = controller.listTodos;
                var listTodosL = controller.listTodos.toString();
                var dayKey = listTodos.keys.elementAt(index);
                var day = dayKey;
                var todos = listTodos[dayKey];
                if (todos.isEmpty && controller.selectedTab == 0) {
                  return SizedBox.shrink();
                }
                var today = DateTime.now();
                if (dayKey == dateFormart.format(today)) {
                  day = 'HOJE';
                } else if (dayKey ==
                    dateFormart.format(today.add(Duration(days: 1)))) {
                  day = 'AMANHÃ';
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              day,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await Navigator.of(context).pushNamed(
                                  NewTaskPage.routerName,
                                  arguments: dayKey);
                              controller.update();
                            },
                            icon: Icon(
                              Icons.add_circle,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: todos.length,
                      itemBuilder: (_, index) {
                        var todo = todos[index];
                        return Dismissible(
                          key: Key('item ${listTodosL[index]}'),
                          background: Container(
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(Icons.delete, color: Colors.white),
                                  Text('Deletar',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          confirmDismiss: (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirmar Exclusão"),
                                  content: Text(
                                      "Você tem certeza que quer deletar esta task?"),
                                  actions: <Widget>[
                                    MaterialButton(
                                        onPressed: () => Navigator.of(context)
                                            .pop(controller.deleteTask(todo)),
                                        child: Text("Deletar")),
                                    MaterialButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text("Cancelar"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },                         
                          child: ListTile(
                            leading: Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              value: todo.finalizado,
                              onChanged: (bool value) =>
                                  controller.checkOrUncheck(todo),
                            ),
                            title: Text(
                              todo.descricao,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  decoration: todo.finalizado
                                      ? TextDecoration.lineThrough
                                      : null),
                            ),
                            trailing: Text(
                              '${todo.dataHora.hour.toString().padLeft(2, '0')}:${todo.dataHora.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  decoration: todo.finalizado
                                      ? TextDecoration.lineThrough
                                      : null),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
