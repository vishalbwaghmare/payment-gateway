import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_getway/core/fade_page_route.dart';
import 'package:payment_getway/screens/home/main_screen.dart';
import 'package:payment_getway/screens/login/bloc/login_bloc.dart';
import 'package:payment_getway/screens/login/repository/authentication_repository.dart';
import 'package:payment_getway/screens/login/sign_up.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //final _formKey = GlobalKey<FormState>();
  //bool _isObscure = true;
  final ImageProvider _loginBgImage = const AssetImage("images/login_bg.jpg");

  @override
  void didChangeDependencies() {
    precacheImage(_loginBgImage, context);
    super.didChangeDependencies();
  }

  /*@override
  void initState() {
    super.initState();
  }*/

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.formStatus == FormSubmissionStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Login Failed: Please check your credentials"),
              ),
            );
        } else if (state.formStatus == FormSubmissionStatus.success) {
          Navigator.pushReplacement(
            context,
            FadePageRoute(child: MainScreen()),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("Login Successful")));
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            height: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.white70,
                  //Colors.purple.shade100,
                  //Colors.grey.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform: GradientRotation(pi / -5),
              ),
              /*image: DecorationImage(
                image: _loginBgImage,
                fit: BoxFit.cover,
              //colorFilter: ColorFilter.mode(Colors.white70, BlendMode.darken)
            ),*/
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 120),
                  CircleAvatar(
                    backgroundColor: Colors.white70,
                    radius: 60,
                    child: Icon(Icons.person, size: 90, color: Colors.grey),
                  ),
                  const SizedBox(height: 50),
                  Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (email) {
                          context.read<LoginBloc>().add(
                            OnEmailChangedEvent(email),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          errorText: state.email.isEmpty || state.isEmailValid
                              ? null
                              : "Please enter a valid email",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black12,
                              width: 1,
                            ),
                          ),
                          suffixIcon: Icon(Icons.email_outlined),
                          suffixIconColor: Colors.black,
                          labelStyle: TextStyle(color: Colors.blueGrey),
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: state.isObscure,
                        onChanged: (value) {
                          context.read<LoginBloc>().add(
                            OnPasswordChangedEvent(value),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          errorText:
                              state.password.isEmpty || state.isPasswordValid
                              ? null
                              : "Please enter a valid password",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black12,
                              width: 1,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.isObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                context.read<LoginBloc>().add(
                                  OnPasswordObscuredEvent(),
                                );
                              });
                            },
                          ),
                          suffixIconColor: Colors.black,
                          labelStyle: TextStyle(color: Colors.blueGrey),
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              state.isEmailValid &&
                                  state.isPasswordValid &&
                                  state.formStatus !=
                                      FormSubmissionStatus.loading
                              ? () {
                                  context.read<LoginBloc>().add(
                                    OnLoginFormSubmittedEvent(),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            disabledBackgroundColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:
                              state.formStatus == FormSubmissionStatus.loading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("Login", style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(thickness: 1, color: Colors.blue),
                          ),
                          Text(
                            " Or ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Divider(thickness: 1, color: Colors.blue),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Register",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                FadePageRoute(child: SignUpScreen()),
                              );
                            },
                            style: TextButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                            ),
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                color: Colors.blue.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
