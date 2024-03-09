import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout
            return Column(
              children: buildLocationContainers(
                  ['Delhi', 'Ahmedabad', 'Roorkee', 'Una']),
            );
          } else if (constraints.maxWidth < 900) {
            // Tablet layout
            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buildLocationContainers(
                    ['Delhi', 'Ahmedabad', 'Roorkee', 'Una']),
              ),
            );
          } else {
            // Desktop layout
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.jpg'), fit: BoxFit.cover)),
                  
                ),
                Container(
                  color: Colors.transparent.withOpacity(0.5),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: buildLocationContainers([
                        'Delhi',
                        'Ahmedabad',
                        'Roorkee',
                        'Una',
                      ]),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }

  List<Widget> buildLocationContainers(List<String> locations) {
    return locations.map((location) {
      return Container(
        width: 200,
        height: 200,
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade600,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Text(
            location,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.0, color: Colors.white),
          ),
        ),
      );
    }).toList();
  }
}
