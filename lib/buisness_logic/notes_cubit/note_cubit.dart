import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../helpers/utils.dart';
import '../model/note.dart';
import '../services/notes_repository.dart';
import 'note_state.dart';

class NoteCubit extends Cubit<NoteState> with HydratedMixin {
  final NotesRepository _notesRepository;
  NoteCubit(this._notesRepository) : super(NoteState.initial());

  Future getAllNotes(String token) async {
    List<Note> notesListdb = [];
    emit(state.copyWith(isLoading: true));
    // log(state.isLoading.toString());

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
          notesListdb.add(note);
        }
        // log(notesListdb.toString());

        // log(listsAreEqual(notesListdb, state.notesList).toString());
        emit(state.copyWith(
            notesList: Utils.listsAreEqual(notesListdb, state.notesList) ? state.notesList : notesListdb,
            isLoading: false));
        // log(state.notesList.toString());
        // log(state.isLoading.toString());
      } else {
        log(response.statusCode.toString());
      }
    } else {
      log('response is null');
    }
  }

  Future updateNotesLocal(String token) async {
    List<Note> newNotesList = [];

    // Get Data from Database and save it in empty List
    Response? response = await NotesRepository().getNotes(token);

    if (response != null) {
      if (response.statusCode == 200) {
        List<dynamic> notesListDB = jsonDecode(response.body)['data'];
        for (var notesListItems in notesListDB) {
          Note newNote = state.selectednote.copyWith(
              id: int.tryParse(notesListItems['id']),
              title: notesListItems['attributes']['title'],
              description: notesListItems['attributes']['description'],
              isFavorite: notesListItems['attributes']['isFavorite'] == 0 ? false : true,
              createdAt: DateTime.tryParse(notesListItems['attributes']['created_at']),
              updatedAt: DateTime.tryParse(notesListItems['attributes']['updated_at']));

          newNotesList.add(newNote);
        }
        if (!Utils.listsAreEqual(state.notesList, newNotesList)) {
          List<Note> localStateList = state.notesList;
          for (int i = 0; i < newNotesList.length; i++) {
            if (newNotesList[i] != localStateList[i]) {
              localStateList[i] = newNotesList[i];
              log('updated');
            }
          }

          emit(state.copyWith(notesList: localStateList));
        }
      } else {
        log('${response.statusCode}');
      }
    }
  }

  // function to delete note
  Future deleteNoteLocal(int id, String token) async {
    Response? response = await NotesRepository().deleteNote(token, id);
    if (response != null) {
      if (response.statusCode == 200) {
        log('deleted');

        // delete note from local state
        List<Note> newNotesList = state.notesList;
        newNotesList.removeWhere((element) => element.id == id);
        emit(state.copyWith(notesList: newNotesList));
      } else {
        log('${response.statusCode}');
      }
    } else {
      log('response is null');
    }
  }

  @override
  NoteState? fromJson(Map<String, dynamic> json) {
    return NoteState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(NoteState state) {
    return state.toMap();
  }
}
