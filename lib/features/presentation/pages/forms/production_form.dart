import 'dart:io';

import 'package:business_app/features/data/model/employee.dart';
import 'package:business_app/features/data/model/location.dart';
import 'package:business_app/features/data/model/product.dart';
import 'package:business_app/features/presentation/pages/Dashboard/production_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductionForm extends StatefulWidget {
  @override
  _ProductionFormState createState() => _ProductionFormState();
}

class _ProductionFormState extends State<ProductionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productionDateController =
      TextEditingController();
  final TextEditingController _productionWeightController =
      TextEditingController();
  final TextEditingController _productionSetController =
      TextEditingController();
  LocationModel? _selectedLocation;
  Employee? _selectedEmployee;
  XFile? _pickedImage;
Product? _selectedProduct;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchLastProductId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Production Form'),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductionListScreen(),
                  ));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProductImageContainer(),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _productIdController,
                  decoration: InputDecoration(
                    labelText: 'Product ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 10.0),
                _buildLocationDropdown(),
                SizedBox(height: 10.0),
                _buildProductDropdown(),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _productionDateController,
                  decoration: InputDecoration(
                    labelText: 'Production Date',
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
                      _productionDateController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select Production Date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                _buildEmployeeDropdown(),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _productionWeightController,
                  decoration: InputDecoration(
                    labelText: 'Weight Per Set',
                    hintText: 'weight',
                    suffix: Text('Kg/Set'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Calculate and update production set
                    double weight = double.tryParse(value) ?? 0;
                    _productionSetController.text =
                        (weight / 10).toStringAsFixed(2);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Production Weight';
                    }
                    return null;
                  },
                ),
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
                      child: Text('Save'),
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

  Widget _buildProductImageContainer() {
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
                  Icons.image,
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

  Widget _buildLocationDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('locations').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        List<LocationModel> locations = snapshot.data!.docs
            .map((doc) => LocationModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        return DropdownButtonFormField<LocationModel>(
          value: _selectedLocation,
          onChanged: (newValue) {
            setState(() {
              _selectedLocation = newValue!;
            });
          },
          decoration: InputDecoration(
            labelText: 'Location',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          items: locations.map((location) {
            return DropdownMenuItem<LocationModel>(
              value: location,
              child: ListTile(
                title: Text(location.id ?? ''),
                subtitle: Text(location.name ?? ''),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildProductDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        List<Product> products = snapshot.data!.docs
            .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        return DropdownButtonFormField<Product>(
          value: _selectedProduct,
          onChanged: (newValue) {
            setState(() {
              _selectedProduct = newValue!;
              _productIdController.text = newValue.id ?? '';
              _productNameController.text = newValue.name ?? '';
            });
          },
          decoration: InputDecoration(
            labelText: 'Product ID',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          items: products.map((product) {
            return DropdownMenuItem<Product>(
              value: product,
              child: ListTile(
                title: Text(product.id ?? ''),
                subtitle: Text(product.name ?? ''),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmployeeDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('employees').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        List<Employee> employees = snapshot.data!.docs
            .map((doc) => Employee.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        return DropdownButtonFormField<Employee>(
          value: _selectedEmployee,
          onChanged: (newValue) {
            setState(() {
              _selectedEmployee = newValue!;
            });
          },
          decoration: InputDecoration(
            labelText: 'Operating Employees',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          items: employees.map((employee) {
            return DropdownMenuItem<Employee>(
              value: employee,
              child: ListTile(
                title: Text(employee.id ?? ''),
                subtitle: Text(employee.name ?? ''),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(employee.employeeImage ?? ''),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _fetchLastProductId() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('products')
        .orderBy('productId', descending: true)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      String lastProductId = querySnapshot.docs.first['productId'];
      String nextProductId = _generateNextProductId(lastProductId);
      _productIdController.text = nextProductId;
    } else {
      // If no previous product, start with a default ID
      _productIdController.text = 'PROD-001';
    }
  }

  String _generateNextProductId(String lastProductId) {
    // Assuming the format is PROD-XXX
    String prefix = lastProductId.substring(0, 5);
    int lastNumber = int.parse(lastProductId.substring(5));
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
              .child('product_images/${_productIdController.text}');
          await storageRef.putFile(File(_pickedImage!.path));
          final imageUrl = await storageRef.getDownloadURL();
          
          // Store data in Firestore with the document ID
          await _firestore.collection('products').doc().set({
            'productId': _productIdController.text,
            'productName': _productNameController.text,
            'location': _selectedLocation!.toJson(),
            'date': _productionDateController.text,
            'employee': _selectedEmployee!.toJson(),
            'weight': double.parse(_productionWeightController.text),
            'set': double.parse(_productionSetController.text),
            'productImageURL': imageUrl,
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
