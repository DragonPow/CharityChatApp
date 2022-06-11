part of 'root_app_bloc.dart';

abstract class RootAppState extends Equatable {
  const RootAppState();
  
  @override
  List<Object> get props => [];
}

class RootAppInitial extends RootAppState {}

class RootAppChangeTapSuccess extends RootAppState{
  final int tap;
  const RootAppChangeTapSuccess({Key? key, required this.tap});
  @override
  List<Object> get props => [tap];
}
