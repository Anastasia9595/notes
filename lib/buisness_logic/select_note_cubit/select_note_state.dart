part of 'select_note_cubit.dart';

class SelectNoteState extends Equatable {
  final bool isNoteSelected;

  const SelectNoteState({required this.isNoteSelected});

  SelectNoteState copyWith({bool? isNoteSelected}) {
    return SelectNoteState(isNoteSelected: isNoteSelected ?? this.isNoteSelected);
  }

  factory SelectNoteState.initial() {
    return const SelectNoteState(isNoteSelected: false);
  }

  @override
  List<Object> get props => [isNoteSelected];
}
