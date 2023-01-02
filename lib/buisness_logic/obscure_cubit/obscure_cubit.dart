import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'obscure_state.dart';

class ObscureCubit extends Cubit<ObscureState> {
  ObscureCubit() : super(ObscureState.initial());
  void toggleObscure() {
    emit(state.copyWith(obscureTextfield: !state.obscureTextfield));
  }
}
