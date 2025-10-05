import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage("images/login_bg.jpg"),
                fit: BoxFit.cover
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 120,),
              CircleAvatar(
                backgroundColor: Colors.white70,
                radius: 90,
                child: Icon(Icons.person, size: 90,color: Colors.grey,),
              ),
              const SizedBox(height: 50,),
              Form(
                key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.black,width: 1.5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.black12,width: 1),
                          ),
                          suffixIcon: Icon(Icons.email_outlined),
                          suffixIconColor: Colors.black,
                          labelStyle: TextStyle(
                            color: Colors.blueGrey
                          ),
                          hintStyle: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.black,width: 1.5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.black12,width: 1),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                          suffixIconColor: Colors.black,
                          labelStyle: TextStyle(
                            color: Colors.blueGrey
                          ),
                          hintStyle: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                            onPressed: (){},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                          ),
                            child: Text("Login"),
                        ),
                      )
                    ],
                  )
              )
            ],
          ),
        ),
    );
  }
}