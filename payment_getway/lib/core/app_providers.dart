import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_getway/main.dart';

import '../screens/login/repository/authentication_repository.dart';

class AppProviders extends StatelessWidget{
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<FirebaseAuthenticationRepository>(
              create: (context) => FirebaseAuthenticationRepository()),
        ],
        child: MyApp(),
    );
  }
}