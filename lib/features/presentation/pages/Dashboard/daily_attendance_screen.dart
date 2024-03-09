import 'package:business_app/features/presentation/pages/Dashboard/OwnerDashboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyAttendanceScreen extends StatefulWidget {
  @override
  _DailyAttendanceScreenState createState() => _DailyAttendanceScreenState();
}

class _DailyAttendanceScreenState extends State<DailyAttendanceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DateTime _selectedDate;

  late bool _attendanceTaken = false;
  List<String> _presentList = [];
  List<String> _absentList = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _checkAttendanceStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Attendance'),
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => OwnerDashboardScreen(),));
        }, icon: Icon(Icons.arrow_back_ios)),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _selectDate(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20.0),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('employees') .orderBy('employeeId',descending: false).snapshots(),
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
                      var data =
                          documents[index].data() as Map<String, dynamic>;

                      return ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(data['employeeImageURL'] ?? ''),
                        ),
                        title: Text('Employee ID: ${data['employeeId']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Employee Name: ${data['employeeName']}'),
                          ],
                        ),
                        trailing: Wrap(
                          spacing: 7,
                          children: <Widget>[
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: _absentList.contains(data['employeeId'])
                                    ? Colors.red
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.zero,
                                  ),
                                ),
                                onPressed: () {
                                  _toggleAttendance(
                                      data['employeeId'], 'Absent');
                                },
                                child: Text('A'),
                              ),
                            ),
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: _presentList.contains(data['employeeId'])
                                    ? Colors.green
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.zero,
                                  ),
                                ),
                                onPressed: () {
                                  _toggleAttendance(
                                      data['employeeId'], 'Present');
                                },
                                child: Text('P'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          SizedBox(height: 20.0),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("Today's Attendance:", 
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 20
              ),),
            ),
          ),



          if (_attendanceTaken)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('attendance')
                    .doc(_formattedDate(_selectedDate))
                    .collection('employees')
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
                        var data =
                            documents[index].data() as Map<String, dynamic>;
                        String employeeId = data['employeeId'];
                        String status = data['status'];
                        String employeeName = data['employeeName'];

                        return ListTile(
                          title: Text('Employee ID: $employeeId'),
                          subtitle: Text(
                              'Employee Name: $employeeName - Status: $status'),
                        );
                      },
                    );
                  }
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveAttendance();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime(3000),
      initialDate: _selectedDate,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _checkAttendanceStatus();
      });
    }
  }

  void _checkAttendanceStatus() {
    _firestore
        .collection('attendance')
        .doc(_formattedDate(_selectedDate))
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          _attendanceTaken = true;
        });
      } else {
        setState(() {
          _attendanceTaken = false;
        });
      }
    });
  }

  void _toggleAttendance(String employeeId, String status) {
    setState(() {
      if (status == 'Present') {
        if (_presentList.contains(employeeId)) {
          _presentList.remove(employeeId);
          _absentList.add(employeeId);
        } else {
          _presentList.add(employeeId);
          _absentList.remove(employeeId);
        }
      } else {
        if (_absentList.contains(employeeId)) {
          _absentList.remove(employeeId);
          _presentList.add(employeeId);
        } else {
          _absentList.add(employeeId);
          _presentList.remove(employeeId);
        }
      }
    });
  }

  void _saveAttendance() {
    _firestore
        .collection('attendance')
        .doc(_formattedDate(_selectedDate))
        .set({'date': _formattedDate(_selectedDate)}).then((_) {
      for (String employeeId in _presentList) {
        _firestore
            .collection('attendance')
            .doc(_formattedDate(_selectedDate))
            .collection('employees')
            .doc(employeeId)
            .set({
          'employeeId': employeeId,
          'status': 'Present',
          'employeeName': 'Employee Name'
        });
      }

      for (String employeeId in _absentList) {
        _firestore
            .collection('attendance')
            .doc(_formattedDate(_selectedDate))
            .collection('employees')
            .doc(employeeId)
            .set({
          'employeeId': employeeId,
          'status': 'Absent',
          'employeeName': 'Employee Name'
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Attendance saved successfully.'),
        ),
      );
    });
  }

  String _formattedDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
