import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import '../model/note.dart';
import '../services/notes_repository.dart';
import 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final NotesRepository _notesRepository;
  NoteCubit(this._notesRepository) : super(NoteState.initial());

  Future getNotes(String token) async {
    List<Note> notes = [];
    emit(state.copyWith(isLoading: true));
    log(state.isLoading.toString());

    Response? response = await NotesRepository().getNotes(token);
    if (response != null) {
      if (response.statusCode == 200) {
        List<dynamic> notesList = jsonDecode(response.body)['data'];

        for (var notesListItems in notesList) {
          final Note note = state.selectednote.copyWith(
              id: int.tryParse(notesListItems['id']),
              title: notesListItems['attributes']['title'],
              description: notesListItems['attributes']['description'],
              isFavorite: notesListItems['attributes']['isFavorite'] == 0 ? false : true,
              createdAt: DateTime.tryParse(notesListItems['attributes']['created_at']),
              updatedAt: DateTime.tryParse(notesListItems['attributes']['updated_at']));
          notes.add(note);
        }
        emit(state.copyWith(notesList: notes, isLoading: false));
        log(state.notesList.toString());
        log(state.isLoading.toString());
      } else {
        log(response.statusCode.toString());
      }
    } else {
      log('response is null');
    }
  }
}
