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
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildDeleteCard(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'TERMINATION',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w800,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Remove Student\nRecords',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E293B),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Identify the student recording using their unique ID to permanently remove it.',
          style: TextStyle(
            color: Colors.blueGrey[400],
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _idController,
            decoration: const InputDecoration(
              labelText: 'Student ID',
              prefixIcon: Icon(Icons.badge_outlined, color: Colors.indigo),
              hintText: 'STU-12345',
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _deleteById(),
          ),
          const SizedBox(height: 32),
          _buildDeleteButton(),
          const SizedBox(height: 24),
          _buildWarningBox(),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.red[600]!, Colors.red[800]!],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _deleteById,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text('Confirm Deletion'),
      ),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.amber[800]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Warning: This action is permanent and cannot be undone.',
              style: TextStyle(color: Colors.amber[900], fontSize: 13, fontWeight: FontWeight.w500),
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
