import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notes_laravel/helpers/constants.dart';
import 'package:notes_laravel/presentation/components/listtilenote_component.dart';
import 'package:notes_laravel/presentation/widgets/floatinaction_button_widget.dart';

import '../../../buisness_logic/notes_cubit/note_cubit.dart';
import '../../../buisness_logic/notes_cubit/note_state.dart';
import '../../../buisness_logic/login_cubit/login_cubit.dart';

class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // log(context.read<NoteCubit>().state.notesList.toString());
    String token = context.read<LoginCubit>().state.user.token;
    context.read<NoteCubit>().updateNotesLocal(token);
    return Scaffold(
        backgroundColor: kBackgroundColorDark,
        body: Column(
          children: [
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0),
                child: Text(
                  'Welcome',
                  style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            BlocBuilder<NoteCubit, NoteState>(
              builder: (context, state) {
                return Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.notesList.length,
                    itemBuilder: (context, index) {
                      if (state.notesList.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      } else {
                        return ListTileNoteComponent(note: state.notesList[index]);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: const CustomFloatinActionButton(
          backgroundcolor: Colors.amber,
          icon: Icons.add,
          iconcolor: Colors.black,
        ));
  }

  Widget buildNotes(List notes) {
    return ListView.builder(
      itemCount: notes.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(notes[index]['attributes']['title']),
        );
      },
    );
  }
}
