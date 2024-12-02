class UserModel {
  int? id;
  String username;
  String email;
  String password;

  UserModel(
      {this.id,
      required this.username,
      required this.email,
      required this.password});

  // Convert a UserModel into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  // Create a UserModel from a Map object.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }
}
