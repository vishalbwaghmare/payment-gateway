import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_getway/screens/login/bloc/login_bloc.dart';
import '../login/login_page.dart';
import '../razorpay_payment.dart';
import '../users/presentation/user_screen.dart';

class MenuBottomSheetContent extends StatelessWidget {
  const MenuBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.formStatus == FormSubmissionStatus.unAuthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
          );
        } else if (state.formStatus == FormSubmissionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign Out Failed: ${state.errorMessage}')),
          );
        }
      },
      child: BottomSheet(
          onClosing: () {
            Navigator.pop(context);
          },
          builder: (context) {
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
                  Divider(thickness: 1, color: Colors.grey),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text("Payments"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RazorPaymentContainer(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Users"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Sign out"),
                    onTap: () {
                      context.read<LoginBloc>().add(OnSignOut());
                    },
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}