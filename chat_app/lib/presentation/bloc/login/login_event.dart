part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}
class LoginPageLogin extends LoginEvent{
  final String email;
  final String pass;
   const LoginPageLogin({Key? key, required this.email, required this.pass});
}
