class Account {
  String id;
  String name;
  String? imageUri;

  static Account? _instance;
  static Account? get instance => _instance;
  void setAccount(String id, String name, String? imageUri) {
    _instance = Account._(id: id, name: name, imageUri: imageUri);
  }

  void setAccountNull() {
    _instance = null;
  }

  Account._({required this.id, required this.name, required this.imageUri});

  static void saveLocalStorage() {}
  static void loadLocalStorage(Account info) {}
}
