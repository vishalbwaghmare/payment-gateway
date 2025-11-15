import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';
import 'package:payment_getway/screens/profile/repository/user_profile_respository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final UserProfileRepository _userProfileRepository;

  ProfileBloc({required UserProfileRepository userProfileRepository})
      : _userProfileRepository = userProfileRepository,
        super(ProfileState.initial()) {
    on<OnLoadUserProfile>(_onLoadUserProfile);
    on<OnProfilePictureChange>(_onProfilePictureChange);
    on<OnSignOutEvent>(_onSignOutEvent);
    on<OnChangePasswordEvent>(_onChangePasswordEvent);
  }

  Future<void> _onLoadUserProfile(OnLoadUserProfile event, Emitter<ProfileState> emit)async {
    emit(state.copyWith(
      status: ProfileStatus.loading,
    ));

    try {
      final User? user = _userProfileRepository.currentUser;
      if(user != null){
        final ImageProvider imageProvider = user.photoURL != null
            ? NetworkImage(user.photoURL!)
            : state.profilePicture;

        emit(state.copyWith(
          status: ProfileStatus.success,
          name: user.displayName ?? "Update your name",
          profilePicture: imageProvider,
        ));
      } else{
        emit(state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: "User not found",
        ));
      }

    }catch(e){
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onProfilePictureChange(OnProfilePictureChange event, Emitter<ProfileState> emit)async {
    emit(state.copyWith(
      status: ProfileStatus.loading,
    ));


  }

  Future<void> _onSignOutEvent(OnSignOutEvent event, Emitter<ProfileState> emit)async {
    try{
      await _userProfileRepository.signOut();
      emit(state.copyWith(status: ProfileStatus.unauthenticated));
    }catch(e){
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onChangePasswordEvent(OnChangePasswordEvent event, Emitter<ProfileState> emit)async {
    try{
      await _userProfileRepository.changePassword();
      emit(state.copyWith(
        status: ProfileStatus.success,
        errorMessage: "Password reset email sent",
      ));
    }catch(e){
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
