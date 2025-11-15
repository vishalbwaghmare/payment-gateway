part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure, unauthenticated }

class ProfileState extends Equatable {
  final String name;
  final String email;
  final ImageProvider profilePicture;
  final ProfileStatus status;
  final String errorMessage;

  const ProfileState({
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.status,
    required this.errorMessage,
});

  factory ProfileState.initial(){
    return ProfileState(
        name: "",
        email: "",
        profilePicture: AssetImage(""),
        errorMessage: "",
        status: ProfileStatus.initial
    );
  }

  ProfileState copyWith({
    String? name,
    String? email,
    ImageProvider? profilePicture,
    ProfileStatus? status,
    String? errorMessage,
}){
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
}

  @override
  List<Object> get props => [name, profilePicture, status, errorMessage];
}

