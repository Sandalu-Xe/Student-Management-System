class Student {
  final String id;
  final String name;
  final String studentId;
  final String degree;

  Student({
    required this.id,
    required this.name,
    required this.studentId,
    required this.degree,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'studentId': studentId,
      'degree': degree,
    };
  }

  factory Student.fromMap(String id, Map<String, dynamic> map) {
    return Student(
      id: id,
      name: map['name'] ?? '',
      studentId: map['studentId'] ?? '',
      degree: map['degree'] ?? '',
    );
  }
}
