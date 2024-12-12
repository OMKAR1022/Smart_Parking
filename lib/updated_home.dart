import 'package:eda/register.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_parking.dart';

class HomePage2 extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch registered cars from Firestore
  Stream<List<Map<String, dynamic>>> fetchRegisteredCars() {
    return _firestore.collection('registered_cars').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Cars',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 10,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.teal),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.local_parking, color: Colors.teal),
              title: Text('Pay Parking'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PayParkingPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Animated Banner
          Container(
            height: 200,
            child: Lottie.network('https://lottie.host/d25d4ccb-8297-4489-b360-1e7106cbaae9/sSYmnz12UG.json'),
          ),

          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: fetchRegisteredCars(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No cars registered yet!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                } else {
                  final cars = snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading: Icon(
                            Icons.directions_car,
                            color: Colors.teal,
                            size: 40,
                          ),
                          title: Text(
                            car['owner_name'] ?? 'Unknown Owner',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Car Number: ${car['car_number'] ?? 'N/A'}\nFlat: ${car['flat_number'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Icon(
                            Icons.verified,
                            color: Colors.green,
                          ),
                        ),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewCarRegistrationPage()),
          );
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
}