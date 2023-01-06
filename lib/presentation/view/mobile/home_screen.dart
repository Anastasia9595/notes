import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_laravel/buisness_logic/model/note.dart';

import 'package:notes_laravel/helpers/constants.dart';
import 'package:notes_laravel/helpers/utils.dart';
import 'package:notes_laravel/presentation/components/custom_alertdialog.dart';
import 'package:notes_laravel/presentation/components/listtilenote_component.dart';
import 'package:notes_laravel/presentation/widgets/floatinaction_button_widget.dart';

import '../../../buisness_logic/notes_cubit/note_cubit.dart';
import '../../../buisness_logic/notes_cubit/note_state.dart';
import '../../../buisness_logic/login_cubit/login_cubit.dart';

class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({super.key});
  Widget buildSwipeLeftAction() => Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 32,
        ),
      );
  Widget buildSwipeRightAction() => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 32,
        ),
      );

  @override
  Widget build(BuildContext context) {
    context.read<NoteCubit>().updateNotesLocal(context.read<LoginCubit>().state.user.token);
    return Scaffold(
        backgroundColor: kBackgroundColorDark,
        body: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0),
                child: BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    return Text(
                      'Welcome ${state.user.name}',
                      style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                    );
                  },
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
                        return Dismissible(
                            background: buildSwipeLeftAction(),
                            secondaryBackground: buildSwipeRightAction(),
                            confirmDismiss: (direction) => Future.delayed(
                                  const Duration(milliseconds: 200),
                                  () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlrtDialog(
                                      backgroundColor: Colors.blueGrey.shade100,
                                      iconBackgroundColor: Colors.blueGrey.shade100,
                                      icon: Icons.delete,
                                      title: 'Delete Note',
                                      titleColor: Colors.black,
                                      content: const Text('Are you sure you want to delete this note?'),
                                      functions: [
                                        () {
                                          Navigator.of(context).pop(false);
                                        },
                                        () {
                                          String token = context.read<LoginCubit>().state.user.token;
                                          context.read<NoteCubit>().deleteNoteLocal(state.notesList[index].id, token);
                                          Navigator.of(context).pop(true);
                                        }
                                      ],
                                      functionNames: const ['No', 'Yes'],
                                    ),
                                  ),
                                ),
                            key: Key(state.notesList[index].toString()),
                            child: ListTileNoteComponent(note: state.notesList[index]));
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
