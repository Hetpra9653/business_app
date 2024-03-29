import 'package:business_app/features/presentation/pages/Dashboard/employee_list_scren.dart';
import 'package:business_app/features/presentation/pages/Dashboard/inventory_list.dart';
import 'package:business_app/features/presentation/pages/Dashboard/master_screen.dart';
import 'package:business_app/features/presentation/pages/Dashboard/production_list.dart';
import 'package:business_app/features/presentation/pages/Dashboard/sell_product_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OwnerDashboardScreen extends StatefulWidget {
  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  final user= FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
    Map<int, Map<String, dynamic>> Dashboard_Details = {
      0: {
        'child': Icon(Icons.folder,size: 50,),
        'name': 'Master',
        'onTap': () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MasterDetailScreen(),));
        }
      },
      1: {
        'child': Icon(Icons.factory,size: 50,),
        'name': 'Production Details',
        'onTap': () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductionListScreen(),));
        }
      },
      2: {
        'child': Icon(CupertinoIcons.folder_badge_plus, size: 50,),
        'name': 'Orders',
        'onTap': () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmployeeListScreen(),));
        }
      },
      3: {
        'child': Icon(Icons.production_quantity_limits,size: 50,),
        'name': 'Rejection Details',
        'onTap': () {
          Navigator.pop(context);
        }
      },
      4: {
        'child': Icon(Icons.inventory,size: 50,),
        'name': 'Inventory',
        'onTap': () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InventoryListScreen(),));
        }
      },
      5: {
        'child': Image.asset('assets/images/truck.png',height: 60,),
        'name': 'Dispacted Details',
        'onTap': () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SellListScreen(),));
        }
      },
      6: {
        'child': Icon(Icons.sell,size: 50,),
        'name': 'Sales',
        'onTap': () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SellListScreen(),));
        }
      }
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Owner Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('employees').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("${snapshot.error.toString()}");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, Prasant',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: Dashboard_Details.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: InkWell(
                              onTap: Dashboard_Details[index]!['onTap'],
                              child: Container(
                                height: 140,
                                width: 140,
                                decoration: BoxDecoration(
                                    color: Color(0xffBEDCFE),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Dashboard_Details[index]!['child'],
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        Dashboard_Details[index]!['name'],
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
