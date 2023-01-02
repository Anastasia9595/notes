import 'dart:developer';

import 'package:http/http.dart';

import '../../helpers/urls.dart';

class NotesRepository {
  Future<Response?> getNotes(String token) async {
    try {
      Response response = await get(Uri.parse(Urls.notes), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      return response;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
