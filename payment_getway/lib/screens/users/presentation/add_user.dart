import 'package:flutter/material.dart';

import '../models/database_helper.dart';
import '../models/user.dart';

class AddUser extends StatefulWidget{
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();

}

class _AddUserState extends State<AddUser>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final newUser = User(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
      );

      await DatabaseHelper.instance.insertUser(newUser);

      Navigator.of(context).pop(true); // Indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      constraints: BoxConstraints(
        maxHeight: 300,
        maxWidth: 400,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Form(
        key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Center(child: Text("Add User",style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),)),
                SizedBox(height: 10,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hint: Text("Enter username"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Enter username' : null,
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _emailController,
                        validator: (val) {
                          if(val == null || val.trim().isEmpty) return "Enter email";
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if(!emailRegex.hasMatch(val)) return "Enter valid email";
                        },
                        decoration: InputDecoration(
                            hint: Text("Enter email"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                Row
                  (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: (){Navigator.pop(context);
                    },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black45,
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        child: Text("Cancel",style: TextStyle(color: Colors.white),)),
                    ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black45,
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        child: Text("Add",style: TextStyle(color: Colors.white),)),
                  ],
                )

            ],
            ),
          )
      ),
    );
  }
}