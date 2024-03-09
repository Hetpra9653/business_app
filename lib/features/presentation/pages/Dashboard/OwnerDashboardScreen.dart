import 'package:business_app/features/presentation/pages/Dashboard/daily_attendance_screen.dart';
import 'package:business_app/features/presentation/pages/Dashboard/employee_list_scren.dart';
import 'package:business_app/features/presentation/pages/Dashboard/inventory_list.dart';
import 'package:business_app/features/presentation/pages/Dashboard/production_list.dart';
import 'package:business_app/features/presentation/pages/Dashboard/sell_product_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OwnerDashboardScreen extends StatefulWidget {
  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    Map<int, Map<String, dynamic>> Dashboard_Details = {
      0: {
        'icon': Icons.person_add,
        'name': 'Attendence',
        'onTap': () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DailyAttendanceScreen(),));
        }
      },
      1: {
        'icon': Icons.factory,
        'name': 'Production Details',
        'onTap': () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductionListScreen(),));
        }
      },
      2: {
        'icon': Icons.group,
        'name': 'Employee Details',
        'onTap': () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmployeeListScreen(),));
        }
      },
      3: {
        'icon': Icons.production_quantity_limits,
        'name': 'Rejection Details',
        'onTap': () {
          Navigator.pop(context);
        }
      },
      4: {
        'icon': Icons.inventory,
        'name': 'Inventory',
        'onTap': () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InventoryListScreen(),));
        }
      },
      5: {
        'icon': Icons.sell,
        'name': 'Sell Products',
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
                      'Welcome, Owner!',
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
                                      Icon(Dashboard_Details[index]!['icon'],
                                          size: 50),
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
