import 'package:equatable/equatable.dart';

import '../model/note.dart';

class NoteState extends Equatable {
  final Note selectednote;
  final List<Note> notesList;
  final bool isLoading;

  const NoteState({required this.selectednote, required this.notesList, required this.isLoading});

  factory NoteState.initial() {
    return NoteState(
      selectednote: Note(
        id: 0,
        title: '',
        description: '',
        isFavorite: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      notesList: const [],
      isLoading: false,
    );
  }

  NoteState copyWith({
    Note? selectednote,
    List<Note>? notesList,
    bool? isLoading,
  }) {
    return NoteState(
      selectednote: selectednote ?? this.selectednote,
      notesList: notesList ?? this.notesList,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  //to map
  Map<String, dynamic> toMap() {
    return {
      'selectednote': selectednote.toMap(),
      'notesList': notesList.map((x) => x.toMap()).toList(),
      'isLoading': isLoading,
    };
  }

  //from map
  factory NoteState.fromMap(Map<String, dynamic> map) {
    return NoteState(
      selectednote: Note.fromMap(map['selectednote']),
      notesList: List<Note>.from(map['notesList']?.map((x) => Note.fromMap(x))),
      isLoading: map['isLoading'],
    );
  }

  @override
  List<Object?> get props => [selectednote, notesList];
}
