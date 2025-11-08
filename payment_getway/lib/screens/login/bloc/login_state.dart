part of 'login_bloc.dart';

enum FormSubmissionStatus { initial, loading, success, failure, unAuthenticated }

class LoginState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final FormSubmissionStatus formStatus;
  final bool isObscure;
  final bool isNameValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool doPasswordsMatch;
  final String errorMessage;

  const LoginState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.formStatus = FormSubmissionStatus.initial,
    this.isObscure = true,
    this.isNameValid = false,
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.doPasswordsMatch = false,
    this.errorMessage = '',
  });

  bool get isFormValid => isEmailValid && isPasswordValid && doPasswordsMatch;

  factory LoginState.initial() => const LoginState();

  LoginState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    FormSubmissionStatus? formStatus,
    bool? isObscure,
    bool? isNameValid,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? doPasswordsMatch,
    String? errorMessage,
  }) {
    return LoginState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      formStatus: formStatus ?? this.formStatus,
      isObscure: isObscure ?? this.isObscure,
      isNameValid: isNameValid ?? this.isNameValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      doPasswordsMatch: doPasswordsMatch ?? this.doPasswordsMatch,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    name,
    email,
    password,
    confirmPassword,
    formStatus,
    isObscure,
    isEmailValid,
    isPasswordValid,
    doPasswordsMatch,
    errorMessage,
  ];
}
