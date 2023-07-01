import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_data_base/task.dart';

import 'database.helper.dart';

class AddTaskScreen extends StatefulWidget {
  final Function? updateTaskList;
  const AddTaskScreen({Key? key, this.updateTaskList}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title = '';
  String? _priority;
  DateTime _date = DateTime.now();
  final TextEditingController _textEditingController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('MMMM dd, yyyy');
  final List<String> _prioritys = ["Low", "Medium", "High"];

  _handleDatePicker() async {
    final date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2023),
        lastDate: DateTime(2050));

    if (date != _date) {
      setState(() {
        _date = date as DateTime;
      });
      _textEditingController.text = _dateFormat.format(date!);
    }
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Task task = Task(title: _title, priority: _priority, data: _date);

      // insert DataBase
      if (widget.updateTaskList != null) widget.updateTaskList!();
      DataBaseHelper.instance.insertTask(task);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Title"),
                    onSaved: (input) => _title = input,
                    validator: (input) => input!.trim().isEmpty
                        ? "Please, enter task title"
                        : null,
                  ),
                  TextFormField(
                    controller: _textEditingController,
                    onTap: _handleDatePicker,
                    decoration: const InputDecoration(labelText: "Date"),
                  ),
                  DropdownButtonFormField(
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    decoration: const InputDecoration(labelText: "Priority"),
                    onChanged: (value) {
                      setState(() {
                        _priority = value!;
                      });
                    },
                    items: _prioritys.map((priority) {
                      return DropdownMenuItem<String>(
                          value: priority,
                          child: Text(
                            priority,
                            style: const TextStyle(color: Colors.black),
                          ));
                    }).toList(),
                    value: _priority,
                    validator: (input) => _priority == null
                        ? "Please, select priority level"
                        : null,
                  ),
                  TextButton(onPressed: _submit, child: const Text("Save"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
