import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/database_service.dart';

class UpdateStudent extends StatefulWidget {
  final Student student;
  const UpdateStudent({super.key, required this.student});

  @override
  State<UpdateStudent> createState() => _UpdateStudentState();
}

class _UpdateStudentState extends State<UpdateStudent> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _studentId;
  late String _degree;

  final DatabaseService _db = DatabaseService();

  @override
  void initState() {
    super.initState();
    _name = widget.student.name;
    _studentId = widget.student.studentId;
    _degree = widget.student.degree;
  }

  void _update() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _db.updateStudent(widget.student.id, _name, _studentId, _degree);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student updated successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Student'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Student Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Update the information for this student record.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
                textInputAction: TextInputAction.next,
                validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                onSaved: (val) => _name = val!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _studentId,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  prefixIcon: Icon(Icons.badge),
                ),
                textInputAction: TextInputAction.next,
                validator: (val) => val!.isEmpty ? 'Please enter an ID' : null,
                onSaved: (val) => _studentId = val!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _degree,
                decoration: const InputDecoration(
                  labelText: 'Degree Program',
                  prefixIcon: Icon(Icons.school),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _update(),
                validator: (val) => val!.isEmpty ? 'Please enter a degree' : null,
                onSaved: (val) => _degree = val!,
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: _update,
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'Update Student Info',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
