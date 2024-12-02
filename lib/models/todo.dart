class TodoModel {
  int? id;
  String title;
  String description;

  TodoModel({this.id, required this.title, required this.description});

  // Convert a TodoModel into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  // Create a TodoModel from a Map object.
  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }
}
