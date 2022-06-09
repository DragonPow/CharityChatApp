part of 'main_bloc_bloc.dart';

abstract class MainBlocState extends Equatable {
  const MainBlocState();
  
  @override
  List<Object> get props => [];
}

class MainBlocInitial extends MainBlocState {}

class MainBlocAlreadyLogin extends MainBlocState {}
class MainBlocNotYetLogin extends MainBlocState {}

