part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoadAuth extends AuthEvent {}

class LoginUser extends AuthEvent {
  final String email;
  final String password;

  const LoginUser({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class GoogleLoginUser extends AuthEvent {
  @override
  List<Object> get props => [];
}

class RegisterUser extends AuthEvent {
  final String email;
  final String password;
  final String username;

  const RegisterUser({required this.email, required this.password, required this.username});

  @override
  List<Object> get props => [email, password, username];
}

class LogoutUser extends AuthEvent {}