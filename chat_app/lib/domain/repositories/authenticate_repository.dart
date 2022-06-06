abstract class IAuthenticateRepository {
  Future<String?> logIn(String userName, String password);
  Future<void> logOut();
}