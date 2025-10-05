import 'package:flutter/material.dart';
import 'package:payment_getway/screens/razorpay_payment.dart';
import 'package:payment_getway/screens/users/presentation/user_screen.dart';

import 'login/login_page.dart';

class LandingScreen extends StatefulWidget{
  @override
  State<LandingScreen> createState() => _LandingScreenState();
  
}

class _LandingScreenState extends State<LandingScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue .shade300,
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                    'Welcome to the My App',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,

                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 5,
                textStyle: TextStyle(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
                child: Text("Get started",),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: IconButton(
                  onPressed: (){
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        builder: (context){
                          return Container(
                            padding: EdgeInsets.all(16),
                            height: 500,
                            width: double.infinity,
                            child: Column(
                              children: [
                                Text(
                                  "Menu",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black45,
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                                ListTile(
                                  leading: Icon(Icons.payment),
                                  title: Text("Payments"),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RazorPaymentContainer()));
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text("Users"),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserScreen()));
                                  },
                                )
                              ],
                            ),
                          );
                        }
                    );
                  },
                  splashRadius: 20,
                  splashColor: Colors.white,
                  icon: Icon(Icons.keyboard_arrow_up_outlined)
              ),
            )
          ],
        ),
      ),

    );
  }
}