import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'select_note_state.dart';

class SelectNoteCubit extends Cubit<SelectNoteState> {
  SelectNoteCubit() : super(SelectNoteState.initial());

  void selectNote() {
    emit(state.copyWith(isNoteSelected: !state.isNoteSelected));
  }
}
