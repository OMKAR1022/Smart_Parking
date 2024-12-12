import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class NewCarRegistrationPage extends StatefulWidget {
  @override
  _NewCarRegistrationPageState createState() => _NewCarRegistrationPageState();
}

class _NewCarRegistrationPageState extends State<NewCarRegistrationPage> {
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _carNumberController = TextEditingController();
  final TextEditingController _flatNumberController = TextEditingController();
  final TextEditingController _checkCarNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _isCarFound = false;

  MqttServerClient? client;
  final String topic = "Omkar_Smart_Parking"; // Topic for MQTT

  @override
  void initState() {
    super.initState();
    _connectToMQTT();
  }

  // Connect to MQTT broker
  Future<void> _connectToMQTT() async {
    client = MqttServerClient('broker.hivemq.com', 'flutter_client_12345678');
    client!.port = 1883;
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = _onDisconnected;

    try {
      await client!.connect();
      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        print('MQTT Connected');
        // Subscribe after connecting
        client!.subscribe(topic, MqttQos.exactlyOnce);
      } else {
        print('ERROR: MQTT connection failed');
        _disconnect();
      }
    } catch (e) {
      print('Exception: $e');
      _disconnect();
    }
  }

  // Disconnect from MQTT broker
  void _disconnect() {
    client?.disconnect();
    _onDisconnected();
  }

  // Handle MQTT disconnection
  void _onDisconnected() {
    print('MQTT Disconnected');
  }

  // Publish message to MQTT topic
  void _publishMessage(String message) {
    if (client != null && client!.connectionStatus!.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
      print('Message published: $message');
    } else {
      print('ERROR: MQTT client is not connected.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('MQTT client is not connected.')),
      );
      // Attempt to reconnect and publish again
      _connectToMQTT();
    }
  }

  // Register new car
  void _registerCar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        await FirebaseFirestore.instance.collection('registered_cars').add({
          'owner_name': _ownerNameController.text.trim(),
          'car_number': _carNumberController.text.trim(),
          'flat_number': _flatNumberController.text.trim(),
          'registration_date': FieldValue.serverTimestamp(),
          'is_verified': true,
        });

        // Send message to turn on LED via MQTT
        _publishMessage('CHECK_CAR');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Car registered successfully!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register car: $e')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // Check if car is already registered
  void _checkCar() async {
    setState(() {
      _isCarFound = false;
    });

    final carNumber = _checkCarNumberController.text.trim();

    if (carNumber.isNotEmpty) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('registered_cars')
          .where('car_number', isEqualTo: carNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _isCarFound = true;
        });
        // Send message to turn on LED via MQTT
        _publishMessage('CHECK_CAR');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Car found! LED turned on.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Car not found.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a car number.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register or Check Car'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Car Registration or Check-in',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 16),
              // New Car Registration Form
              TextFormField(
                controller: _ownerNameController,
                decoration: InputDecoration(
                  labelText: 'Owner Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter owner name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _carNumberController,
                decoration: InputDecoration(
                  labelText: 'Car Number',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter car number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _flatNumberController,
                decoration: InputDecoration(
                  labelText: 'Flat Number',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter flat number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              _isSubmitting
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _registerCar,
                child: Text('Register Car'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 32),
              // Car Check-In Form
              TextFormField(
                controller: _checkCarNumberController,
                decoration: InputDecoration(
                  labelText: 'Enter Car Number to Check',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkCar,
                child: Text('Check Car'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 16),
              _isCarFound
                  ? Text(
                'Car found! LED is turned on.',
                style: TextStyle(color: Colors.green),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
