part of 'root_app_bloc.dart';

abstract class RootAppEvent  {
  const RootAppEvent();


}

class RootAppChangeTap extends RootAppEvent{
  final int tap;
   const RootAppChangeTap ({Key? key, required this.tap});

}

