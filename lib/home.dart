import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Parking'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.brown,
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Fastag ID at the top center
                  Text(
                    'FASTag ID: 333',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Column(
                      children: [
                        Text(
                          'In Time:',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          '10.22',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Out Time:',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '11.20',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date:',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '11-2-2024',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total: 250',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              color: Colors.brown,
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Fastag ID at the top center
                  Text(
                    'FASTag ID: 334543',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'In Time:',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '6.22',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Out Time:',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '4.20',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date:',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '15-2=6-2024',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total: 550',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              color: Colors.brown,
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Fastag ID at the top center
                  Text(
                    'FASTag ID: 1231233',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'In Time:',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '2:30',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Out Time:',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '11.20',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date:',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '27-2-2024',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total: 750',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              color: Colors.brown,
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Fastag ID at the top center
                  Text(
                    'FASTag ID: 1289333',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'In Time:',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '12:15',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Out Time:',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '1:15',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date:',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '11-2-2024',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total: 100',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              color: Colors.brown,
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Fastag ID at the top center
                  Text(
                    'FASTag ID: 546738',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'In Time:',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '10.22',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Out Time:',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '11.20',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date:',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '11-2-2024',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total: 450',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 86, // Adjust height if needed
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(Icons.home),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(Icons.settings),
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add camera functionality or navigation here
          print("Camera button tapped");
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
