import '../models/user_model.dart';

abstract class IUserRemoteDataSource {
    Future<List<UserModel>> getActiveUsers(int startIndex, int number);
    Future<UserModel> getUserById(String userId);
    Future<List<UserModel>> getUsersInRoom(String roomId);

    Future<List<UserModel>> findUsersByName(String textMatch);

    Future<String?> logIn(String userName, String password);
    Future<bool> logOut();
}