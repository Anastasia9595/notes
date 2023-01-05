import 'dart:developer';

import 'package:http/http.dart';

import '../../helpers/urls.dart';
import '../../helpers/utils.dart';

class NotesRepository {
  Future<Response?> getNotes(String token) async {
    try {
      Response response = await get(
        Uri.parse(Urls.notes),
        headers: Utils.headerHelperFunction(token),
      );

      return response;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  // function to delete note
  Future<Response?> deleteNote(String token, int id) async {
    try {
      Response response = await delete(
        Uri.parse('${Urls.notes}/$id'),
        headers: Utils.headerHelperFunction(token),
      );

      return response;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
