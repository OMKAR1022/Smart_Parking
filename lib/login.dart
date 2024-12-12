import 'package:eda/home.dart';
import 'package:eda/updated_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;


  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        // Navigate to HomePage after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred, please try again.";
      if (e.code == 'user-not-found') {
        message = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password provided for that user.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      // Catch any other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected error: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFff9966),
                Color(0xFFff5e62),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              Lottie.network('https://lottie.host/d25d4ccb-8297-4489-b360-1e7106cbaae9/sSYmnz12UG.json'),
              SizedBox(height: 10),
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Login to your account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Color(0xFFff5e62)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Color(0xFFff5e62)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Handle forgot password
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
               // onPressed: _login,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage2()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFff5e62),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Don’t have an account? Sign up',
                style: TextStyle(color: Colors.white70),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
