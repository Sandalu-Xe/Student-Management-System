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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildGlassForm(),
          ],
        ),
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
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'MODIFICATION',
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.w800,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Update Student\nInformation',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E293B),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Modify the details for ${widget.student.name} and save changes to the database.',
          style: TextStyle(
            color: Colors.blueGrey[400],
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline_rounded),
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
                prefixIcon: Icon(Icons.badge_outlined),
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
                prefixIcon: Icon(Icons.school_outlined),
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _update(),
              validator: (val) => val!.isEmpty ? 'Please enter a degree' : null,
              onSaved: (val) => _degree = val!,
            ),
            const SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _update,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text('Save Changes'),
      ),
    );
  }
}
