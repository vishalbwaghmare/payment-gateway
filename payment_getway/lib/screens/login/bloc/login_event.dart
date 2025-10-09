part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class OnEmailChangedEvent extends LoginEvent {
  final String email;

  const OnEmailChangedEvent(this.email);

  @override
  List<Object> get props => [email];
}

class OnPasswordChangedEvent extends LoginEvent{
  final String password;
  const OnPasswordChangedEvent(this.password);

  @override
  List<Object> get props => [password];

}

class OnLoginFormSubmittedEvent extends LoginEvent{
  const OnLoginFormSubmittedEvent();

  @override
  List<Object> get props => [];

}

class OnConfirmPasswordChangedEvent extends LoginEvent{
  final String confirmPassword;

  const OnConfirmPasswordChangedEvent(this.confirmPassword);
  @override
  List<Object> get props => [confirmPassword];
}
class OnSignUpEvent extends LoginEvent{
  final String email;
  final String password;

  const OnSignUpEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class OnPasswordObscuredEvent extends LoginEvent{
  const OnPasswordObscuredEvent();

  @override
  List<Object> get props => [];
}
