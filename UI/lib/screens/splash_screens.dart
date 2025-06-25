import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/signin'); // or use logic to check login
    });

    return Scaffold(
      backgroundColor: Color(0xFFF8EFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.phone_android, size: 100, color: Colors.black),
            SizedBox(height: 20),
            Text("unbiasart", style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text("Look for the truth"),
          ],
        ),
      ),
    );
  }
}