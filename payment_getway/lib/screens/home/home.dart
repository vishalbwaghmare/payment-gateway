import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  final User? _user = FirebaseAuth.instance.currentUser;
  final bool _hasNotification = true;

  @override
  Widget build(BuildContext context) {
    final ImageProvider? profileImage = _user?.photoURL != null ? NetworkImage(_user!.photoURL!) : null;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){},
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: profileImage,
                  child: profileImage == null
                    ? Icon(Icons.person,size: 25,)
                    : null,
                ),
              ),
              IconButton(
                  onPressed: (){},
                  icon: Badge(
                    isLabelVisible: _hasNotification,
                    child: Icon(
                      Icons.notifications_none,
                      size: 30,
                    ),
                  )
              )
            ],
          )
        ],
      ),
    );
}
}