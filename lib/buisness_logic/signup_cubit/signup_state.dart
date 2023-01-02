part of 'signup_cubit.dart';

enum SignupStatus { initial, sucess, failed, logout, userexist }

class SignupState extends Equatable {
  final User user;
  final SignupStatus isSubmitting;

  const SignupState({required this.user, required this.isSubmitting});

  SignupState copyWith({
    User? user,
    SignupStatus? isSubmitting,
  }) {
    return SignupState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      user: user ?? this.user,
    );
  }

  factory SignupState.initial() {
    return const SignupState(user: User.empty, isSubmitting: SignupStatus.initial);
  }

  // create to map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'user': user.toMap(), 'isSubmitting': isSubmitting.index};
  }

  // create from map
  factory SignupState.fromMap(Map<String, dynamic> map) {
    return SignupState(
      user: User.fromMap(map['user']),
      isSubmitting: SignupStatus.values[map['isSubmitting']],
    );
  }

  @override
  List<Object> get props => [user, isSubmitting];
}
