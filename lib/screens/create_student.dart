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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 100),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  suffixIcon: Icon(Icons.close),
                ),
                validator: (val) => val!.isEmpty ? 'Enter a name' : null,
                onSaved: (val) => _name = val!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Id',
                  suffixIcon: Icon(Icons.close),
                ),
                validator: (val) => val!.isEmpty ? 'Enter an ID' : null,
                onSaved: (val) => _studentId = val!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Degree',
                  suffixIcon: Icon(Icons.close),
                ),
                validator: (val) => val!.isEmpty ? 'Enter a degree' : null,
                onSaved: (val) => _degree = val!,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
