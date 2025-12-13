class User {
  final int id;
  final String email;
  final String username;
  User({required this.id, required this.email, required this.username});
  factory User.fromJson(Map<String, dynamic> js) => User(id: js['Id'], email: js['Email'], username: js['Username']);
}
