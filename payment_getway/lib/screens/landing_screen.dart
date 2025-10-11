import 'dart:math';

import 'package:flutter/material.dart';
import 'package:payment_getway/core/fade_page_route.dart';
import 'package:payment_getway/screens/razorpay_payment.dart';
import 'package:payment_getway/screens/users/presentation/user_screen.dart';

import 'login/login_page.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.blue.shade300,
                Colors.purple.shade400,
                Colors.pink.shade200,
              ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            transform: GradientRotation(pi /4)
          ),
            //color: Colors.blue.shade300
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Welcome to the My App',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  FadePageRoute(child: LoginPage())
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 5,
                textStyle: TextStyle(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Get started"),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
