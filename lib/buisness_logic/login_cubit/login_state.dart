part of 'login_cubit.dart';

enum LoginStatus { initial, success, falseData, logout, failed, falsePassword }

class LoginState extends Equatable {
  final User user;
  final LoginStatus isSubmitting;
  const LoginState({required this.user, required this.isSubmitting});

  LoginState copyWith({
    User? user,
    LoginStatus? isSubmitting,
  }) {
    return LoginState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      user: user ?? this.user,
    );
  }

  factory LoginState.initial() {
    return const LoginState(user: User.empty, isSubmitting: LoginStatus.initial);
  }

  // LoginState copyWithUser(User user) {
  //   return LoginState(user: user, isSubmitting: isSubmitting);
  // }

  //create to map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'user': user.toMap(), 'isSubmitting': isSubmitting.index};
  }

  //create from map
  factory LoginState.fromMap(Map<String, dynamic> map) {
    return LoginState(
      user: User.fromMap(map['user']),
      isSubmitting: LoginStatus.values[map['isSubmitting']],
    );
  }

  @override
  List<Object> get props => [user, isSubmitting];
}
