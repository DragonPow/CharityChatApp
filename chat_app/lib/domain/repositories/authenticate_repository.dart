abstract class IAuthenticateRepository {
  Future<void> logIn(String userName, String password);
  Future<void> logOut();
}