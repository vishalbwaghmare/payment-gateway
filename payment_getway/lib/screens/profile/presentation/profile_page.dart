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
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
          );
        } else if (state.status == ProfileStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
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
                  context.read<ProfileBloc>().add(const OnSignOutEvent());
                }, 
                icon: Icon(Icons.logout))],
          ),
            body: SingleChildScrollView(
              child: Column(
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
                  ),
                  const SizedBox(height: 16,),
                  _buildTile(
                      context,
                      icon: Icons.edit,
                      title: state.name,
                      onTap: (){}
                  ),
                  _buildTile(
                      context,
                      title: _user?.email ?? "Add your email address",
                      onTap: (){}
                  ),
                  _buildTile(
                      context,
                      title: "Change Password",
                      onTap: (){
                        context.read<ProfileBloc>().add(OnChangePasswordEvent());
                      }
                  ),
                  _buildTile(
                      context,
                      title: "Delete Account",
                      onTap: (){}
                  ),
                ],
              ),
            ));
      },
    );
  }
}

Widget _buildTile(
BuildContext context,{
   IconData? icon,
   required String title,
   Color? textColor,
   Color? iconColor,
   required VoidCallback? onTap,
}){
  return ListTile(
    //leading: Icon(icon, color: iconColor ?? Colors.blueAccent,),
    title: Text(
      title,
      style: TextStyle(
        color: textColor ?? Colors.black,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: Icon(icon, color: iconColor ?? Colors.blueAccent,),
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
  );

}