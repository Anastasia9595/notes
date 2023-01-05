import 'dart:developer';

import 'package:http/http.dart';
import 'package:notes_laravel/helpers/urls.dart';

class AuthRepository {
  Future<Response?> signIn({required String email, required String password}) async {
    try {
      Response response = await post(Uri.parse(Urls.login), body: {
        'email': email,
        'password': password,
      });
      return response;
    } catch (e) {
      log('error in signIn function');
      log(e.toString());
    }
    return null;
  }

  Future<Response?> signUp(
      {required String name,
      required String email,
      required String password,
      // ignore: non_constant_identifier_names
      required String password_confirmation}) async {
    try {
      Response response = await post(Uri.parse(Urls.registration), body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password_confirmation,
      });
      return response;
    } catch (e) {
      log('error in signUp function $e');
    }
    return null;
  }

  Future<Response?> signOut({required String token}) async {
    //int statuscode;
    try {
      Response response = await post(Uri.parse(Urls.logout), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      //statuscode = response.statusCode;
      //log(response.body);
      return response;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  // function to get current user
  // Future<User?> getUser(String token) async {
  //   try {
  //     Response response = await get(Uri.parse(Urls.user), headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     });
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }
}
