import 'dart:io';

import 'package:business_app/features/data/model/employee.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EmployeeForm extends StatefulWidget {
  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _employeeBirthdateController =
      TextEditingController();
  final TextEditingController _employeeJoiningDateController =
      TextEditingController();
  final TextEditingController _employeeSalaryController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  String _selectedBranch = 'Ahmedabad'; // Default branch
  String _selectedJobType = 'Full time'; // Default job type
  XFile? _pickedImage;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchLastEmployeeId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text('Employee Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileImageContainer(),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _employeeIdController,
                  decoration: InputDecoration(
                    labelText: 'Employee ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _employeeNameController,
                  decoration: InputDecoration(
                    labelText: 'Employee Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Employee Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _employeeBirthdateController,
                  decoration: InputDecoration(
                    labelText: 'Employee Birthdate',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (selectedDate != null &&
                        selectedDate != DateTime.now()) {
                      _employeeBirthdateController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select Employee Birthdate';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _employeeJoiningDateController,
                  decoration: InputDecoration(
                    labelText: 'Employee Joining Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (selectedDate != null &&
                        selectedDate != DateTime.now()) {
                      _employeeJoiningDateController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select Employee Joining Date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: _selectedBranch,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedBranch = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Employee Branch',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: ['Ahmedabad', 'Una', 'Bakrol']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _employeeSalaryController,
                  decoration: InputDecoration(
                    labelText: 'Employee Monthly Salary',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Employee Monthly Salary';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Phone number';
                    } else if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _aadharController,
                  decoration: InputDecoration(
                    labelText: 'Aadhar Details',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Aadhar number';
                    } else if (value.length != 12) {
                      return 'Aadhar number must be 12 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: _selectedJobType,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedJobType = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Job Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: ['Full time', 'Part time', 'Per Day']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10.0),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _resetForm();
                      },
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageContainer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _pickedImage != null
            ? CircleAvatar(
                radius: 50.0,
                backgroundImage: FileImage(File(_pickedImage!.path)),
              )
            : Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: Icon(
                  Icons.person,
                  size: 50.0,
                  color: Colors.grey[600],
                ),
              ),
        Positioned(
          bottom: 10,
          right: 120,
          child: CircleAvatar(
            radius: 17,
            backgroundColor: Colors.grey,
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                color: Colors.black,
                onPressed: () {
                  _pickImage();
                },
                icon: Icon(Icons.edit, size: 17),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _fetchLastEmployeeId() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('employees')
        .orderBy('employeeId', descending: true)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      String lastEmployeeId = querySnapshot.docs.first['employeeId'];
      String nextEmployeeId = _generateNextEmployeeId(lastEmployeeId);
      _employeeIdController.text = nextEmployeeId;
    } else {
      // If no previous employee, start with a default ID
      _employeeIdController.text = 'EMP-001';
    }
  }

  String _generateNextEmployeeId(String lastEmployeeId) {
    // Assuming the format is EMP-XXX
    String prefix = lastEmployeeId.substring(0, 4);
    int lastNumber = int.parse(lastEmployeeId.substring(4));
    int nextNumber = lastNumber + 1;
    return '$prefix${nextNumber.toString().padLeft(3, '0')}';
  }

  void _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed to store data in Firestore
      try {
        // Upload the image to Firebase Storage
        if (_pickedImage != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('employee_images/${_employeeIdController.text}');
          await storageRef.putFile(File(_pickedImage!.path));
          final imageUrl = await storageRef.getDownloadURL();

          // Store data in Firestore
          await _firestore.collection('employees').add({
            'EmployeeDetails': Employee(
              id: _employeeIdController.text,
              name: _employeeNameController.text,
              birthdate: _employeeBirthdateController.text,
              joiningDate: _employeeJoiningDateController.text,
              location: _selectedBranch,
              salary: double.parse(_employeeSalaryController.text).toString(),
              phonenumber: _phoneController.text,
              aadharNumber: _aadharController.text,
              mode: _selectedJobType,
              employeeImage: imageUrl,
            )
          });

          // Optional: Show a success message or navigate to another screen
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Form submitted successfully')));
        } else {
          // Handle case where no image is picked
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Please pick an image')));
        }
      } catch (error) {
        // Handle error
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $error')));
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _pickedImage = null;
    });
  }
}
