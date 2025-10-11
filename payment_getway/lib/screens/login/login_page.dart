import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_getway/core/fade_page_route.dart';
import 'package:payment_getway/screens/home/home.dart';
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
          authenticationRepository: context.read<AuthenticationRepository>()
      ),
      child: LoginView(),
    );
  }

}

class LoginView extends StatefulWidget{
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>{
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
    return BlocConsumer<LoginBloc, LoginState>(
  listener: (context, state) {
    if(state.formStatus == FormSubmissionStatus.failure){
      ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Login Failed: Please check your credentials"))
          );
    }else if(state.formStatus == FormSubmissionStatus.success){
      Navigator.pushReplacement(context, FadePageRoute(child: MainScreen()));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text("Login Successful"))
        );
    }
  },
  builder: (context, state) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage("images/login_bg.jpg"),
                fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.white70, BlendMode.darken)
            ),
          ),
          child: SingleChildScrollView(
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
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (email){
                            context.read<LoginBloc>().add(OnEmailChangedEvent(email));
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            errorText: state.email.isEmpty || state.isEmailValid ? null : "Please enter a valid email",
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
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isObscure,
                          onChanged: (value){
                            context.read<LoginBloc>().add(OnPasswordChangedEvent(value));
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            errorText: state.password.isEmpty || state.isPasswordValid ? null : "Please enter a valid password",
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
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                              onPressed: state.isEmailValid  && state.isPasswordValid && state.formStatus != FormSubmissionStatus.loading
                                  ? (){context.read<LoginBloc>().add(OnLoginFormSubmittedEvent());
                              }: null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                            ),
                              child: state.formStatus == FormSubmissionStatus.loading
                                  ?CircularProgressIndicator(color: Colors.white,)
                                  :Text("Login"),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              " Or ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                              ),
                            ),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(context, FadePageRoute(child: SignUpScreen()));
                                },
                                style: TextButton.styleFrom(
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                child: Text(
                                    "Sign up",
                                  style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 14
                                  ),
                                )
                            )
                          ],
                        )
                      ],
                    )
                )
              ],
            ),
          ),
        ),
    );
  },
);
  }
}