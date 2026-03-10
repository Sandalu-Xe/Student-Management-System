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
    
    try {
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Remove Student',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the Student ID to remove their record from the system.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 48),
          TextField(
            controller: _idController,
            decoration: const InputDecoration(
              labelText: 'Student ID',
              prefixIcon: Icon(Icons.badge, color: Colors.indigo),
              hintText: 'e.g. STU12345',
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _deleteById(),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _deleteById,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.delete_forever),
            label: const Text(
              'Confirm Deletion',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.amber[800]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Warning: This action is permanent and cannot be undone.',
                    style: TextStyle(color: Colors.amber[900], fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
}
