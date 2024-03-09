import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_app/features/presentation/pages/Dashboard/OwnerDashboardScreen.dart';

class InventoryListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory List'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OwnerDashboardScreen()),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('products')
            .orderBy('productId', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var data = documents[index].data() as Map<String, dynamic>;
                double productQuantity = data['productionQuantity'] ?? 0.0;

                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(data['productImageURL'] ?? ''),
                  ),
                  title: Text('Product ID: ${data['productId']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product Name: ${data['productName']}'),
                      Text('Product Quantity: ${productQuantity}'),
                    ],
                  ),
                  trailing: FilledButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)))),
                    onPressed: () {
                      _showSellDialog(context, data['id'], productQuantity.toInt());
                    },
                    child: Text('Sell'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _showSellDialog(BuildContext context, String docId, int productQuantity) async {
    int sellQuantity = 0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sell Product'),
          content: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter the quantity to sell:'),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    sellQuantity = int.tryParse(value) ?? 0;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (sellQuantity > productQuantity) {
                  // Show an error message if sell quantity is greater than product quantity
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sell quantity cannot be greater than product quantity')),
                  );
                } else {
                  // Update Firestore with new quantity
                  _updateProductQuantity(sellQuantity, docId);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Sell'),
            ),
          ],
        );
      },
    );
  }

  void _updateProductQuantity(int sellQuantity, String docId) {
    // Update Firestore with new quantity
    _firestore.collection('products').doc(docId).update({
      'sellQuantity': FieldValue.increment(sellQuantity),
    });
  }
}

class FilledButton extends StatelessWidget {
  final ButtonStyle style;
  final VoidCallback onPressed;
  final Widget child;

  FilledButton({
    required this.style,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );
  }
}
