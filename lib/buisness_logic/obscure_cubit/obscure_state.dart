part of 'obscure_cubit.dart';

class ObscureState extends Equatable {
  final bool obscureTextfield;
  const ObscureState({required this.obscureTextfield});

  ObscureState copyWith({bool? obscureTextfield}) {
    return ObscureState(obscureTextfield: obscureTextfield ?? this.obscureTextfield);
  }

  factory ObscureState.initial() {
    return const ObscureState(obscureTextfield: true);
  }

  @override
  List<Object> get props => [obscureTextfield];
}
