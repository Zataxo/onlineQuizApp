class Question {
  final String? id;
  final String title;
  final List<Map<String, bool>> options;

  //Creating Constructor
  Question({
    required this.id,
    required this.title,
    required this.options,
  });

  @override
  String toString() {
    return 'Question(id: $id, title"$title,options:$options)';
  }
}
