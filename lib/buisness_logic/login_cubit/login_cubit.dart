import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notes_laravel/buisness_logic/services/auth_repository.dart';

import '../model/user.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> with HydratedMixin {
  final AuthRepository _authRepository;
  LoginCubit(this._authRepository) : super(LoginState.initial());

  Future<bool> signIn({required String email, required String password}) async {
    emit(state.copyWith(user: User.empty, isSubmitting: LoginStatus.initial));
    final Response? response = await _authRepository.signIn(email: email, password: password);
    //log(response?.statusCode.toString() ?? 'null');
    if (response != null) {
      if (response.statusCode == 201) {
        // log('Login Success');
        log(jsonDecode(response.body).toString());
        final User user = state.user.copyWith(
          token: jsonDecode(response.body)['token'],
          id: jsonDecode(response.body)['user']['id'],
          name: jsonDecode(response.body)['user']['name'],
          email: jsonDecode(response.body)['user']['email'],
        );

        // log(user.toString());

        emit(state.copyWith(isSubmitting: LoginStatus.success, user: user));
        return true;
      } else if (response.statusCode == 401) {
        //log('User not exist');
        emit(state.copyWith(isSubmitting: LoginStatus.falseData));
        return false;
      } else if (response.statusCode == 402) {
        emit(state.copyWith(isSubmitting: LoginStatus.falsePassword));
        return false;
      }
    } else {
      log('response is null');
      emit(state.copyWith(isSubmitting: LoginStatus.failed));
      return false;
    }
    return false;
  }

  // logut function
  Future<bool> signOut({required String token}) async {
    Response? response = await _authRepository.signOut(token: token);
    if (response != null && response.statusCode == 200) {
      log(response.statusCode.toString());
      emit(state.copyWith(user: User.empty, isSubmitting: LoginStatus.logout));
      return true;
    }
    return false;
  }

  @override
  LoginState? fromJson(Map<String, dynamic> json) {
    return LoginState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(LoginState state) {
    return state.toMap();
  }
}
