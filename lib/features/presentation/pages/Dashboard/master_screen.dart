import 'package:business_app/features/presentation/pages/Dashboard/LocationScreen.dart';
import 'package:business_app/features/presentation/pages/Dashboard/employee_list_scren.dart';
import 'package:business_app/features/presentation/pages/Dashboard/production_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MasterDetailScreen extends StatefulWidget {
  @override
  State<MasterDetailScreen> createState() => _MasterDetailScreenState();
}

class _MasterDetailScreenState extends State<MasterDetailScreen> {
  final user= FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
    Map<int, Map<String, dynamic>> Dashboard_Details = {
      0: {
        'child': Icon(Icons.badge,size: 50,),
        'name': 'Employee Master',
        'onTap': () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmployeeListScreen(),));
        }
      },
      1: {
        'child': Image.asset('assets/images/customer.png', height:60),
        'name': 'Customer Master',
        'onTap': () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductionListScreen(),));
        }
      },
      2: {
        'child': Icon(CupertinoIcons.cube_box, size: 50,),
        'name': 'Product Master',
        'onTap': () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductionListScreen(),));
        }
      },
      3: {
        'child': Icon(Icons.location_on_sharp,size: 50,),
        'name': 'Location Master',
        'onTap': () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LocationScreen(),));
        }
      },
      
      
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Master'),
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
