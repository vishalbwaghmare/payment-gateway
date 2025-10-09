import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_getway/core/fade_page_route.dart';
import 'package:payment_getway/screens/login/bloc/login_bloc.dart';
import 'package:payment_getway/screens/login/login_page.dart';
import 'package:payment_getway/screens/login/repository/authentication_repository.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LoginBloc(
          authenticationRepository: context.read<FirebaseAuthenticationRepository>(),
        ),
        child: SignUp(),
    );
  }
}
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
  listener: (context, state) {
    if(state.formStatus == FormSubmissionStatus.success){
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text("Sign up Successful"))
        );
    }else if(state.formStatus == FormSubmissionStatus.failure){
      final errorMessage = state.errorMessage.isNotEmpty
        ? state.errorMessage
        :"An unknown error occurred during sign-up.";
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text(errorMessage))
        );
    }

  },
  builder: (context, state) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage("images/login_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 120),
            CircleAvatar(
              backgroundColor: Colors.white70,
              radius: 90,
              child: Icon(Icons.person, size: 90, color: Colors.grey),
            ),
            const SizedBox(height: 50),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    onChanged: (email){
                      context.read<LoginBloc>().add(OnEmailChangedEvent(email));
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      errorText: state.email.isEmpty || state.isPasswordValid ? null : state.errorMessage,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black12, width: 1),
                      ),
                      suffixIconColor: Colors.black,
                      labelStyle: TextStyle(color: Colors.blueGrey),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    onChanged: (password){
                      context.read<LoginBloc>().add(OnPasswordChangedEvent(password));
                    },
                    decoration: InputDecoration(
                      hintText: 'Create your password',
                      errorText: state.password.isEmpty || state.isPasswordValid ? null : "Please enter a valid password",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black12, width: 1),
                      ),
                      suffixIconColor: Colors.black,
                      labelStyle: TextStyle(color: Colors.blueGrey),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    onChanged: (value){
                      context.read<LoginBloc>().add(OnConfirmPasswordChangedEvent(value));
                    },
                    decoration: InputDecoration(
                      hintText: 'Confirm password',
                      errorText: state.confirmPassword.isEmpty || state.doPasswordsMatch ? null : "Passwords do not match",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black12, width: 1),
                      ),
                      suffixIconColor: Colors.black,
                      labelStyle: TextStyle(color: Colors.blueGrey),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: state.isEmailValid && state.formStatus != FormSubmissionStatus.loading
                          ?() {
                        context.read<LoginBloc>().add(OnSignUpEvent(state.email, state.password));
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Sign up"),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.white),
                      ),
                      Text(
                        " Or ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            FadePageRoute(
                              child: BlocProvider(
                                create: (context) => LoginBloc(
                                  authenticationRepository: context.read<FirebaseAuthenticationRepository>(),
                                ),
                                child: LoginPage(),
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.cyan, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  },
);
  }
}
