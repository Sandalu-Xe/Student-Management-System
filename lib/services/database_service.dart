import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';

class DatabaseService {
  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('students');

  // Create
  Future<void> addStudent(String name, String studentId, String degree) async {
    return await studentsCollection.add({
      'name': name,
      'studentId': studentId,
      'degree': degree,
    });
  }

  // Read
  Stream<List<Student>> get students {
    return studentsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Student.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Update
  Future<void> updateStudent(
      String id, String name, String studentId, String degree) async {
    return await studentsCollection.doc(id).update({
      'name': name,
      'studentId': studentId,
      'degree': degree,
    });
  }

  // Delete
  Future<void> deleteStudent(String id) async {
    return await studentsCollection.doc(id).delete();
  }
}
