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
        title: const Text('Update'),
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
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  suffixIcon: Icon(Icons.close),
                ),
                validator: (val) => val!.isEmpty ? 'Enter a name' : null,
                onSaved: (val) => _name = val!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _studentId,
                decoration: const InputDecoration(
                  labelText: 'Id',
                  suffixIcon: Icon(Icons.close),
                ),
                validator: (val) => val!.isEmpty ? 'Enter an ID' : null,
                onSaved: (val) => _studentId = val!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _degree,
                decoration: const InputDecoration(
                  labelText: 'Degree',
                  suffixIcon: Icon(Icons.close),
                ),
                validator: (val) => val!.isEmpty ? 'Enter a degree' : null,
                onSaved: (val) => _degree = val!,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _update,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                ),
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
