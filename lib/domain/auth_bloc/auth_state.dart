part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class UserLoadingState extends AuthState {}

class UserLoadedState extends AuthState {}

class AuthFailed extends AuthState {
  final String errorMessage;
  AuthFailed({required this.errorMessage});
}