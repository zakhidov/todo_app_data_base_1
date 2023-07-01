class Task {
  int? id;
  String? title;
  DateTime data;
  String? priority;
  int status = 0;

  Task({required this.title, required this.priority, required this.data});

  Task.withId(
      {this.id,
      required this.title,
      required this.priority,
      required this.data,
      required this.status});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) map["id"] = id;

    map["title"] = title;
    map["data"] = data.toIso8601String();
    map["priority"] = priority;
    map["status"] = status;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
        id: map["id"],
        title: map["title"],
        data: DateTime.parse(map["data"]),
        priority: map["priority"],
        status: map["status"]);
  }
}
