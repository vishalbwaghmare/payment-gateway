import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repository/authentication_repository.dart';


part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(LoginState.initial()) {
    on<OnEmailChangedEvent>(_onEmailChanged);
    on<OnPasswordChangedEvent>(_onPasswordChanged);
    on<OnConfirmPasswordChangedEvent>(_onConfirmPasswordChanged);
    on<OnLoginFormSubmittedEvent>(_onLoginFormSubmitted);
    on<OnSignUpEvent>(_onSignUpEvent);
    on<OnPasswordObscuredEvent>(_onPasswordObscured);
  }

  void _onEmailChanged(OnEmailChangedEvent event, Emitter<LoginState> emit) {
    final isEmailValid = RegExp(r'\S+@\S+\.\S+').hasMatch(event.email);
    emit(state.copyWith(
        email: event.email,
        isEmailValid: isEmailValid,
        errorMessage: "",
        formStatus: FormSubmissionStatus.initial
    ));
  }

  void _onPasswordChanged(OnPasswordChangedEvent event, Emitter<LoginState> emit) {
    final isPasswordValid = event.password.length >= 8;
    final doPasswordsMatch = event.password == state.confirmPassword && state.confirmPassword.isNotEmpty;

    emit(state.copyWith(
      password: event.password,
      isPasswordValid: isPasswordValid,
      doPasswordsMatch: doPasswordsMatch,
      errorMessage: "",
        formStatus: FormSubmissionStatus.initial
    ));
  }

  void _onConfirmPasswordChanged(OnConfirmPasswordChangedEvent event, Emitter<LoginState> emit) {
    final doPasswordsMatch = state.password == event.confirmPassword;
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      doPasswordsMatch: doPasswordsMatch,
      errorMessage: "",
        formStatus: FormSubmissionStatus.initial
    ));
  }


  void _onLoginFormSubmitted(OnLoginFormSubmittedEvent event, Emitter<LoginState> emit) async {
    if (state.formStatus == FormSubmissionStatus.loading) return;
    emit(state.copyWith(formStatus: FormSubmissionStatus.loading,errorMessage: ""));

    try {
      await _authenticationRepository.signInWithEmailAndPassword(state.email, state.password);
      emit(state.copyWith(formStatus: FormSubmissionStatus.success,errorMessage: ""));
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email. Please sign up.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = 'Login failed. Please check your credentials.';
      }
      emit(state.copyWith(
        formStatus: FormSubmissionStatus.failure,
        errorMessage: message
      ));
    } catch (e) {
      emit(state.copyWith(
        formStatus: FormSubmissionStatus.failure,
        errorMessage: 'An unknown error occurred during login.',
      ));
    }
  }

  void _onSignUpEvent(OnSignUpEvent event, Emitter<LoginState> emit) async {
    if (!state.isFormValid || state.formStatus == FormSubmissionStatus.loading) {
      return;
    }

    emit(state.copyWith(formStatus: FormSubmissionStatus.loading,errorMessage: ""));

    try {
      await _authenticationRepository.signUpWithEmailAndPassword(state.email, state.password);

      emit(state.copyWith(
        formStatus: FormSubmissionStatus.success,
        email: "",
        password: "",
        confirmPassword: "",
      ));
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == "email-already-in-use") {
        message = "An account already exists for that email.";
      } else if (e.code == "weak-password") {
        message = "The password provided is too weak.";
      } else {
        message = "An unknown error occurred during sign-up.";
      }
      print("SignUp failed with Firebase error: ${e.code}");
      emit(state.copyWith(formStatus: FormSubmissionStatus.failure,errorMessage: message));
    } catch (e) {
      emit(state.copyWith(
          formStatus: FormSubmissionStatus.failure,
          errorMessage: "Unknown error occurred during sign-up."
      ));
    }
  }

  void _onPasswordObscured(OnPasswordObscuredEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(isObscure: !state.isObscure));
  }
}
