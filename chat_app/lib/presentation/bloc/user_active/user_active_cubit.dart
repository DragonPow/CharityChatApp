import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/user_active_entity.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';

class UserActiveCubit extends Cubit<List<UserActiveEntity>?> {
  final IUserRepository userRepository;
  UserActiveCubit({required this.userRepository}) : super(null);

  Future<void> getUserActives(int startIndex, int number) async {
    try {
      final newUsers = await userRepository.getActiveUsers(startIndex, number);
      if (state != null) {
        newUsers.addAll(state!..removeWhere((user) => newUsers.contains(user)));
      }
      emit(newUsers);
    } catch (e) {
      emit(state);
    }
  }
}
