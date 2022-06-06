class Account {
  String id;
  String name;
  String? imageUri;

  static Account? _instance;
  static Account? get instance => _instance;
  static void setInstanceByCopy(Account? account) {
    _instance = account != null ? Account._(id: account.id, name: account.name, imageUri: account.imageUri) : null;
  }
  static void setInstance(String id, String name, String? imageUri) {
    _instance = Account._(id: id, name: name, imageUri: imageUri);
  }

  // static void setInstanceNull() {
  //   _instance = null;
  // }

  Account._({required this.id, required this.name, required this.imageUri});
  Account({required this.id, required this.name, required this.imageUri});

  static void saveLocalStorage() {}
  static void loadLocalStorage(Account info) {}

  toJson() {
    Map<String,dynamic> e = {
      'id': id,
      'name': name,
      'imageUri': imageUri,
    };
    return e;
  }
}
