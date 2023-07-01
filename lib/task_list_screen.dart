import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_data_base/add_task_screen.dart';
import 'package:todo_app_data_base/database.helper.dart';
import 'package:todo_app_data_base/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> _taskList;
  final DateFormat _dateFormat = DateFormat('MMMM dd, yyyy');

  Widget _builderitem(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: ListTile(
        title: Text(task.title!),
        subtitle: Text(
          _dateFormat.format(task.data),
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Checkbox(
          value: task.status == 0 ? false : true,
          onChanged: (bool? value) {},
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DataBaseHelper.instance.getTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTaskScreen(
                        updateTaskList: _updateTaskList,
                      )));
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _taskList,
        builder: (context, AsyncSnapshot snapshot) {
          return ListView.builder(
              itemCount: snapshot.data != null ? snapshot.data.length + 1 : 0,
              itemBuilder: (BuildContext context, int index) {
                final int completedTaskCount = snapshot.data
                    .where((Task task) => task.status == 1)
                    .toList()
                    .length;

                if (index == 0) {
                  return Container(
                    child: Row(
                      children: [
                        const Text(
                          "My Task",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "$completedTaskCount/${snapshot.data.length}",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return _builderitem(snapshot.data[index - 1]);
                }
              });
        },
      ),
    );
  }
}
