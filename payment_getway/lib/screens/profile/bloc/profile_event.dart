part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class OnLoadUserProfile extends ProfileEvent{
  const OnLoadUserProfile();

  @override
  List<Object?> get props => [];
}

class OnProfilePictureChange extends ProfileEvent{
  const OnProfilePictureChange();

  @override
  List<Object?> get props => [];
}

class OnSignOutEvent extends ProfileEvent{
  const OnSignOutEvent();

  @override
  List<Object?> get props => [];
}
