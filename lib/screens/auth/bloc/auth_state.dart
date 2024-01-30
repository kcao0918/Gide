part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthMissing extends AuthState {}

class AuthConfirmed extends AuthState {
  final self_module.User user;

  const AuthConfirmed({required this.user});

  @override
  List<Object> get props => [user];
}
