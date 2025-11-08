import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../login/login_page.dart';
import '../bloc/profile_bloc.dart';
import '../repository/user_profile_respository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ProfileBloc(
        userProfileRepository: context.read<UserProfileRepository>(),
      )
        ..add(const OnLoadUserProfile()),
      child: const ProfilePageView(),
    );
  }
}

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
          );
        } else if (state.status == ProfileStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
            );
        }
      },
      builder: (context, state) {
        if (state.status == ProfileStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            actions: [IconButton(
                onPressed: (){
                  context.read<ProfileBloc>().add(OnSignOutEvent());
                }, 
                icon: Icon(Icons.logout))],
          ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      context.read<ProfileBloc>().add(OnProfilePictureChange());
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: state.profilePicture,
                      child: Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  state.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: "Roboto"
                  ),
                )
              ],
            ));
      },
    );
  }
}