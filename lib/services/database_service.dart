import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';

class DatabaseService {
  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('students');

  // Create
  Future<void> addStudent(String name, String studentId, String degree) async {
    try {
      await studentsCollection.add({
        'name': name,
        'studentId': studentId,
        'degree': degree,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding student to Firestore: $e");
      rethrow;
    }
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
    try {
      await studentsCollection.doc(id).update({
        'name': name,
        'studentId': studentId,
        'degree': degree,
      });
    } catch (e) {
      print("Error updating student: $e");
      rethrow;
    }
  }

  // Delete
  Future<void> deleteStudent(String id) async {
    try {
      await studentsCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting student: $e");
      rethrow;
    }
  }
}
