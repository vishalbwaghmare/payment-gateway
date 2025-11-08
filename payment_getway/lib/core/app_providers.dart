import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_getway/screens/landing_screen.dart';
import 'package:payment_getway/screens/login/repository/authentication_repository.dart';
import 'package:payment_getway/screens/profile/repository/user_profile_respository.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
            create: (context) => FirebaseAuthenticationRepository()),
        RepositoryProvider<UserProfileRepository>(
            create: (context) => UserProfileRepositoryImpl()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Razorpay Payment Gateway App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const LandingScreen(),
      ),
    );
  }
}
