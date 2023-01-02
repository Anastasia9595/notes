import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notes_laravel/buisness_logic/model/user.dart';

import '../services/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> with HydratedMixin {
  final AuthRepository _authRepository;
  SignupCubit(this._authRepository) : super(SignupState.initial());

  Future<bool> signUp(
      {required String name,
      required String email,
      required String password,
      required String confirmedPassword}) async {
    emit(state.copyWith(user: User.empty, isSubmitting: SignupStatus.initial));
    final Response? response = await _authRepository.signUp(
        name: name, email: email, password: password, password_confirmation: confirmedPassword);
    log(response?.statusCode.toString() ?? 'null');

    if (response != null) {
      if (response.statusCode == 201) {
        final User user = state.user.copyWith(
          token: jsonDecode(response.body)['token'],
          name: jsonDecode(response.body)['user']['name'],
          email: jsonDecode(response.body)['user']['email'],
          id: jsonDecode(response.body)['user']['id'],
        );
        log(user.toString());
        emit(state.copyWith(isSubmitting: SignupStatus.sucess, user: user));
        return true;
      } else if (response.statusCode == 302) {
        emit(state.copyWith(isSubmitting: SignupStatus.userexist));
        return false;
      }
    } else {
      log('response is null');
      emit(state.copyWith(isSubmitting: SignupStatus.failed));
      return false;
    }
    return false;
  }

  Future<void> signOut({required String token}) async {
    final result = await _authRepository.signOut(token: token);
    emit(state.copyWith(user: User.empty, isSubmitting: SignupStatus.logout));
    log(result.toString());
  }

  @override
  SignupState? fromJson(Map<String, dynamic> json) {
    return SignupState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(SignupState state) {
    return state.toMap();
  }
}
