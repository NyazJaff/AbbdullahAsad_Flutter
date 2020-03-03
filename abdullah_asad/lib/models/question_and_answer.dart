class QuestionAndAnswer {
  final int id;
  final int parentId;
  final String title;
  final String question;
  final String answer;
  final String mp3URL;
  final String pdfURL;
  final String createdTime;
  final String type;
  final String category;

  QuestionAndAnswer({ this.id, this.parentId, this.answer, this.createdTime, this.mp3URL, this.pdfURL, this.question, this.title, this.type, this.category});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parentId': parentId,
      'answer': answer,
      'createdTime': createdTime,
      'mp3URL': mp3URL,
      'pdfURL': pdfURL,
      'question': question,
      'title': title,
      'type': type,
      'category': category,

    };
  }

  // Implement toString to make it easier to see information about
  // each book when using the print statement.
  @override
  String toString() {
    return 'QuestionAndAnswer{id: $id, parentId: $parentId, answer: $answer, createdTime: $createdTime, mp3URL: $mp3URL}';
  }
}