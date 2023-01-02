import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String name;
  final String email;
  final String token;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  static const empty = User(id: null, email: '', name: '', token: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      token: map['token'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }

  @override
  List<Object?> get props => [id, name, email, token];
}
