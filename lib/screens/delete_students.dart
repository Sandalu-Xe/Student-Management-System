import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/database_service.dart';

class DeleteStudents extends StatefulWidget {
  const DeleteStudents({super.key});

  @override
  State<DeleteStudents> createState() => _DeleteStudentsState();
}

class _DeleteStudentsState extends State<DeleteStudents> {
  final _idController = TextEditingController();
  final DatabaseService _db = DatabaseService();

  void _deleteById() async {
    String studentIdSearch = _idController.text.trim();
    if (studentIdSearch.isEmpty) return;

    // This screen in the screenshots shows an "Id" field and a "Delete" button.
    // It's a bit ambiguous if it deletes by Document ID or the Custom Student ID.
    // Based on the UI, it's likely a search-then-delete or delete-by-id field.
    // I'll implement a query to find the student with that Student ID and delete them.
    
    final querySnapshot = await _db.studentsCollection
        .where('studentId', isEqualTo: studentIdSearch)
        .get();

    if (querySnapshot.docs.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student not found!')),
        );
      }
      return;
    }

    for (var doc in querySnapshot.docs) {
      await _db.deleteStudent(doc.id);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student deleted successfully!')),
      );
      _idController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 200),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'Id',
                suffixIcon: Icon(Icons.close),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _deleteById,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40),
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
}
