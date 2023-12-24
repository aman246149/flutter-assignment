part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});
}

class LoginSuccessState extends AuthState {
  const LoginSuccessState();
}

class SignupSuccessState extends AuthState {
  const SignupSuccessState();
}
