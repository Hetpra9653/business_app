import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_app/features/data/model/location.dart';

class LocationForm extends StatefulWidget {
  @override
  _LocationFormState createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _locationIdController = TextEditingController();
  final TextEditingController _locationNameController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchLastLocationId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Form'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _locationIdController,
                  decoration: InputDecoration(
                    labelText: 'Location ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _locationNameController,
                  decoration: InputDecoration(
                    labelText: 'Location Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Location Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _fetchLastLocationId() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('locations')
        .orderBy('id', descending: true)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      String lastLocationId = querySnapshot.docs.first['id'];
      String nextLocationId = _generateNextLocationId(lastLocationId);
      setState(() {
        _locationIdController.text = nextLocationId;
      });
    } else {
      // If no previous location, start with a default ID
      setState(() {
        _locationIdController.text = 'LOCID-001';
      });
    }
  }

  String _generateNextLocationId(String lastLocationId) {
    // Assuming the format is LOCID-XXX
    String prefix = lastLocationId.substring(0, 6);
    int lastNumber = int.parse(lastLocationId.substring(6));
    int nextNumber = lastNumber + 1;
    return '$prefix${nextNumber.toString().padLeft(3, '0')}';
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed to store data in Firestore
      try {
        // Store data in Firestore
        await _firestore.collection('locations').add({
          'id': _locationIdController.text,
          'name': _locationNameController.text,
        });

        // Optional: Show a success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location saved successfully')));
      } catch (error) {
        // Handle error
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $error')));
      }
    }
  }
}
