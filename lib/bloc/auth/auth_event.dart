part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent{
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});


}

class SignupEvent extends AuthEvent{
  final String email;
  final String password;
  final String username;

  const SignupEvent({required this.email, required this.password, required this.username});
}

class AuthErrorEvent extends AuthEvent{
  final String message;

  const AuthErrorEvent({required this.message});
}