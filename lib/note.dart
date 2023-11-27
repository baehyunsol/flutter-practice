class Note {
  final String title;
  final String content;

  Note({required this.title, required this.content});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['Title'].toString(),
      content: json['Content'].toString(),
    );
  }
}