part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure, unauthenticated }

class ProfileState extends Equatable {
  final String name;
  final ImageProvider profilePicture;
  final ProfileStatus status;
  final String errorMessage;

  const ProfileState({
    required this.name,
    required this.profilePicture,
    required this.status,
    required this.errorMessage,
});

  factory ProfileState.initial(){
    return ProfileState(
        name: "",
        profilePicture: AssetImage(""),
        errorMessage: "",
        status: ProfileStatus.initial
    );
  }

  ProfileState copyWith({
    String? name,
    ImageProvider? profilePicture,
    ProfileStatus? status,
    String? errorMessage,
}){
    return ProfileState(
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
}

  @override
  List<Object> get props => [name, profilePicture, status, errorMessage];
}

