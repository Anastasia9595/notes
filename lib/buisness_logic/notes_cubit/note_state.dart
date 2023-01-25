import 'package:equatable/equatable.dart';

import '../model/note.dart';

class NoteState extends Equatable {
  final Note selectedNote;
  final List<Note> notesList;
  final List<Note> selectedNotestoDeleteList;
  final bool isLoading;

  const NoteState({
    required this.selectedNote,
    required this.notesList,
    required this.isLoading,
    this.selectedNotestoDeleteList = const [],
  });

  factory NoteState.initial() {
    return NoteState(
      selectedNote: Note(
        id: 0,
        title: '',
        description: '',
        isFavorite: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      notesList: const [],
      selectedNotestoDeleteList: const [],
      isLoading: false,
    );
  }

  NoteState copyWith({
    Note? selectednote,
    List<Note>? notesList,
    List<Note>? selectedNotestoDeleteList,
    bool? isLoading,
  }) {
    return NoteState(
      selectedNote: selectednote ?? selectedNote,
      notesList: notesList ?? this.notesList,
      selectedNotestoDeleteList: selectedNotestoDeleteList ?? this.selectedNotestoDeleteList,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  //to map
  Map<String, dynamic> toMap() {
    return {
      'selectednote': selectedNote.toMap(),
      'notesList': notesList.map((x) => x.toMap()).toList(),
      'isLoading': isLoading,
    };
  }

  //from map
  factory NoteState.fromMap(Map<String, dynamic> map) {
    return NoteState(
      selectedNote: Note.fromMap(map['selectednote']),
      notesList: List<Note>.from(map['notesList']?.map((x) => Note.fromMap(x))),
      isLoading: map['isLoading'],
    );
  }

  @override
  List<Object?> get props => [selectedNote, notesList, selectedNotestoDeleteList, isLoading];
}
