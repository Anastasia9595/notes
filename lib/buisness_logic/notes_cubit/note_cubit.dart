import 'dart:convert';
import 'dart:developer';

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
          final Note note = state.selectedNote.copyWith(
              id: int.tryParse(notesListItems['id']),
              title: notesListItems['attributes']['title'],
              description: notesListItems['attributes']['description'],
              isFavorite: notesListItems['attributes']['isFavorite'] == 0 ? false : true,
              createdAt: DateTime.tryParse(notesListItems['attributes']['created_at']),
              updatedAt: DateTime.tryParse(notesListItems['attributes']['updated_at']));
          notesListdb.add(note);
        }

        emit(state.copyWith(
            notesList: Utils.listsAreEqual(notesListdb, state.notesList) ? state.notesList : notesListdb,
            isLoading: false));
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
          Note newNote = state.selectedNote.copyWith(
              id: int.tryParse(notesListItems['id']),
              title: notesListItems['attributes']['title'],
              description: notesListItems['attributes']['description'],
              isFavorite: notesListItems['attributes']['isFavorite'] == 0 ? false : true,
              createdAt: DateTime.tryParse(notesListItems['attributes']['created_at']),
              updatedAt: DateTime.tryParse(notesListItems['attributes']['updated_at']));

          newNotesList.add(newNote);
        }
        // log('newNotesList: ${newNotesList.length}');
        // log('localStateList: ${state.notesList.length}');

        if (Utils.listsAreEqual(newNotesList, state.notesList) == false) {
          List<Note> localStateList = state.notesList;
          if (localStateList.length == newNotesList.length) {
            for (int i = 0; i < newNotesList.length; i++) {
              if (newNotesList[i] != localStateList[i]) {
                localStateList[i] = newNotesList[i];
                log('updated');
              }
            }
            emit(state.copyWith(notesList: localStateList));
          }

          emit(state.copyWith(notesList: newNotesList));
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

  // delete multiple notes
  Future deleteMultipleNotesLocal(List<int> ids, String token) async {
    Response? response = await NotesRepository().deleteNotes(token, ids);
    log(response?.statusCode.toString() ?? 'repsonse is null');
    if (response != null) {
      if (response.statusCode == 200) {
        updateNotesLocal(token);
      } else {
        log('${response.statusCode}');
      }
    } else {
      log('response is null');
    }
  }

  // clean list
  void cleanselectedNotestoDeleteList() {
    Note targetNote = state.selectedNote;
    for (var element in state.selectedNotestoDeleteList) {
      targetNote = element.copyWith(isNoteSelected: false);
    }
    emit(state.copyWith(
      selectedNotestoDeleteList: [],
      notesList: state.notesList.map((note) => note.id == targetNote.id ? targetNote : note).toList(),
    ));
  }

  void addNoteToRemovedList(int id) {
    List<Note> newRemovedList = [...state.selectedNotestoDeleteList];
    Note targetNote = state.notesList.firstWhere((element) => element.id == id);

    int index = newRemovedList.indexWhere((element) => element.id == id);
    if (index != -1) {
      newRemovedList.removeAt(index);
      targetNote = targetNote.copyWith(isNoteSelected: false);
      log('${targetNote.isNoteSelected}');
    } else {
      targetNote = targetNote.copyWith(isNoteSelected: true);
      newRemovedList.add(targetNote);
      log('${targetNote.isNoteSelected}');
    }

    List<Note> newList = state.notesList.map((note) => note.id == id ? targetNote : note).toList();

    emit(state.copyWith(
      notesList: newList,
      selectedNotestoDeleteList: newRemovedList,
    ));
    log(
      'note added to removed list: ${state.selectedNotestoDeleteList.length}  ${state.selectedNotestoDeleteList.map((e) => e.id).toList()}',
    );
  }

  void setNoteToSelected(Note note) {}

  void setNoteToSelectedFromList(int id) {
    Note note = state.notesList.firstWhere((element) => element.id == id);
    emit(state.copyWith(selectednote: note));
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
