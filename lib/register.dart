import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewCarRegistrationPage extends StatefulWidget {
  @override
  _NewCarRegistrationPageState createState() => _NewCarRegistrationPageState();
}

class _NewCarRegistrationPageState extends State<NewCarRegistrationPage> {
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _carNumberController = TextEditingController();
  final TextEditingController _flatNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;

  void _registerCar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        await FirebaseFirestore.instance.collection('registered_cars').add({
          'owner_name': _ownerNameController.text.trim(),
          'car_number': _carNumberController.text.trim(),
          'flat_number': _flatNumberController.text.trim(),
          'registration_date': FieldValue.serverTimestamp(),
          'is_verified': true,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Car registered successfully!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register car: $e')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register New Car'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'New Car Registration',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ownerNameController,
                decoration: InputDecoration(
                  labelText: 'Owner Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter owner name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _carNumberController,
                decoration: InputDecoration(
                  labelText: 'Car Number',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter car number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _flatNumberController,
                decoration: InputDecoration(
                  labelText: 'Flat Number',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter flat number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              _isSubmitting
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _registerCar,
                child: Text('Register Car'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blueAccent,
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
