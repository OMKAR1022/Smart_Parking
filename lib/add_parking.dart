import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PayParkingPage extends StatefulWidget {
  @override
  _PayParkingPageState createState() => _PayParkingPageState();
}

class _PayParkingPageState extends State<PayParkingPage> {
  final TextEditingController _carNumberController = TextEditingController();
  final TextEditingController _exitCarNumberController = TextEditingController();
  final _formKeyEntry = GlobalKey<FormState>();
  final _formKeyExit = GlobalKey<FormState>();

  final double hourlyRate = 10.0;

  void _registerEntry() async {
    if (_formKeyEntry.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('parking_logs').add({
          'car_number': _carNumberController.text.trim(),
          'entry_time': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Entry registered successfully!')),
        );

        _carNumberController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register entry: $e')),
        );
      }
    }
  }

  void _registerExit() async {
    if (_formKeyExit.currentState!.validate()) {
      try {
        String carNumber = _exitCarNumberController.text.trim();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('parking_logs')
            .where('car_number', isEqualTo: carNumber)
            .get();

        if (querySnapshot.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No active parking found for this car')),
          );
          return;
        }

        DocumentSnapshot carDoc = querySnapshot.docs.first;
        String docId = carDoc.id;
        Map<String, dynamic> data = carDoc.data() as Map<String, dynamic>;

        if (!data.containsKey('entry_time') || data['entry_time'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid entry time for this car')),
          );
          return;
        }

        DateTime entryTime = (data['entry_time'] as Timestamp).toDate();
        DateTime exitTime = DateTime.now();
        Duration duration = exitTime.difference(entryTime);

        double totalHours = duration.inMinutes / 60.0;
        double payment = (totalHours > 0 ? totalHours : 1) * hourlyRate;

        // Generate QR Code with payment details
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Payment QR Code',
                style: TextStyle(fontWeight: FontWeight.bold), // Added styling for title
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8, // Explicit width for dialog
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car Number: $carNumber\n'
                          'Entry Time: ${entryTime.toLocal().toString().split(".")[0]}\n'
                          'Exit Time: ${exitTime.toLocal().toString().split(".")[0]}\n'
                          'Duration: ${duration.inMinutes} minutes\n'
                          'Payment: ₹${payment.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16), // Improved text visibility
                    ),
                    SizedBox(height: 16), // Space between details and QR code
                    Center(
                      child: QrImageView(
                        data: 'Payment for $carNumber: ₹${payment.toStringAsFixed(2)}',
                        version: QrVersions.auto,
                        size: 150.0, // Adjusted QR code size
                        backgroundColor: Colors.white, // Ensures proper visibility
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    try {
                      // Remove car from database after showing QR code
                      await FirebaseFirestore.instance
                          .collection('parking_logs')
                          .doc(docId)
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Payment processed and record deleted.')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: Unable to delete record.')),
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.red), // Styled button
                  ),
                ),
              ],
            );
          },
        );



        _exitCarNumberController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register exit: $e')),
        );
      }
    }
  }

  Widget _buildParkingList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('parking_logs').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No vehicles in the parking area.'));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.directions_car, color: Colors.blue),
                title: Text('Car Number: ${data['car_number']}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    'Entry Time: ${(data['entry_time'] as Timestamp).toDate()}'),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay Parking System',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vehicle Entry',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKeyEntry,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _carNumberController,
                      decoration: InputDecoration(
                        labelText: 'Car Number',
                        prefixIcon: Icon(Icons.directions_car),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter car number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _registerEntry,
                      child: Text('Register Entry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Divider(color: Colors.grey.shade700),
              SizedBox(height: 20),
              Text(
                'Vehicles in Parking Area',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800),
              ),
              SizedBox(height: 20),
              Container(
                height: 200,
                child: _buildParkingList(),
              ),
              SizedBox(height: 40),
              Divider(color: Colors.grey.shade700),
              SizedBox(height: 20),
              Text(
                'Vehicle Exit',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKeyExit,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _exitCarNumberController,
                      decoration: InputDecoration(
                        labelText: 'Car Number',
                        prefixIcon: Icon(Icons.directions_car),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter car number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _registerExit,
                      child: Text('Register Exit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
