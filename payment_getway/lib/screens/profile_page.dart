import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePageView extends StatefulWidget{
  const ProfilePageView({super.key});

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView>{
  final User? _user = FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _user?.photoURL != null
                  ? NetworkImage(_user!.photoURL!)
                   :null,
                child: _user?.photoURL == null
                  ?Icon(Icons.person,size: 50,)
                    :null,
              ),
            ),
            SizedBox(height: 20,),
            Text(
              _user?.email ?? "No email added",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: "Roboto"
              ),
            )
          ],
        ));
  }
}