import 'package:flutter/material.dart';
import '../services/database_service.dart';

class CreateStudent extends StatefulWidget {
  const CreateStudent({super.key});

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _studentId = '';
  String _degree = '';

  final DatabaseService _db = DatabaseService();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _db.addStudent(_name, _studentId, _degree);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student added successfully!')),
        );
        _formKey.currentState!.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Student',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fill in the details below to register a new student.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
                hintText: 'e.g. John Doe',
              ),
              textInputAction: TextInputAction.next,
              validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
              onSaved: (val) => _name = val!,
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Student ID',
                prefixIcon: Icon(Icons.badge),
                hintText: 'e.g. STU12345',
              ),
              textInputAction: TextInputAction.next,
              validator: (val) => val!.isEmpty ? 'Please enter an ID' : null,
              onSaved: (val) => _studentId = val!,
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Degree Program',
                prefixIcon: Icon(Icons.school),
                hintText: 'e.g. Computer Science',
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: (val) => val!.isEmpty ? 'Please enter a degree' : null,
              onSaved: (val) => _degree = val!,
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text(
                'Register Student',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
