part of 'login_bloc.dart';

enum FormSubmissionStatus { initial, loading, success, failure, unAuthenticated }

class LoginState extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;
  final FormSubmissionStatus formStatus;
  final bool isObscure;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool doPasswordsMatch;
  final String errorMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.formStatus = FormSubmissionStatus.initial,
    this.isObscure = true,
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.doPasswordsMatch = false,
    this.errorMessage = '',
  });

  bool get isFormValid => isEmailValid && isPasswordValid && doPasswordsMatch;

  factory LoginState.initial() => const LoginState();

  LoginState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    FormSubmissionStatus? formStatus,
    bool? isObscure,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? doPasswordsMatch,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      formStatus: formStatus ?? this.formStatus,
      isObscure: isObscure ?? this.isObscure,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      doPasswordsMatch: doPasswordsMatch ?? this.doPasswordsMatch,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
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
