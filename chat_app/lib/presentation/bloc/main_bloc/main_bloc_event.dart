part of 'main_bloc_bloc.dart';

abstract class MainBlocEvent extends Equatable {
  const MainBlocEvent();

  @override
  List<Object> get props => [];
}

class MainBlocCheck extends MainBlocEvent{
}
class MainBlocLogin extends MainBlocEvent{
}

class MainBlocLogout extends MainBlocEvent{}