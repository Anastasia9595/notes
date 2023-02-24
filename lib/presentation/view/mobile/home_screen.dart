import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_laravel/buisness_logic/select_note_cubit/select_note_cubit.dart';

import 'package:notes_laravel/helpers/constants.dart';
import 'package:notes_laravel/presentation/components/custom_alertdialog.dart';
import 'package:notes_laravel/presentation/components/listtilenote_component.dart';
import 'package:notes_laravel/presentation/view/mobile/new_note_screen.dart';
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
    // context.read<NoteCubit>().updateNotesLocal(context.read<LoginCubit>().state.user.token);

    return Scaffold(
        backgroundColor: kBackgroundColorDark,
        appBar: AppBar(
          backgroundColor: kBackgroundColorDark,
          elevation: 0,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
          actions: [
            BlocBuilder<NoteCubit, NoteState>(
              builder: (context, state) {
                return BlocBuilder<SelectNoteCubit, SelectNoteState>(
                  builder: (context, slectedNoteState) {
                    return slectedNoteState.isNoteSelected
                        ? IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              String token = context.read<LoginCubit>().state.user.token;
                              log(token.toString());
                              List<int> selectedNotes =
                                  context.read<NoteCubit>().state.selectedNotestoDeleteList.map((e) => e.id).toList();
                              context.read<NoteCubit>().deleteMultipleNotesLocal(selectedNotes, token);
                              state.selectedNotestoDeleteList.clear();
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          );
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            BlocBuilder<NoteCubit, NoteState>(
              builder: (context, state) {
                return Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'All Notes ${state.notesList.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                );
              },
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
                            child: BlocBuilder<SelectNoteCubit, SelectNoteState>(
                              builder: (context, seletNoteState) {
                                return InkWell(
                                  onLongPress: () {
                                    context.read<SelectNoteCubit>().selectNote();
                                    // seletNoteState.isNoteSelected == false
                                    //     ? null
                                    //     : context.read<NoteCubit>().addNoteToRemovedList(state.notesList[index].id);
                                    // context.read<NoteCubit>().addNoteToRemovedList(state.notesList[index].id);
                                  },
                                  onTap: () {
                                    seletNoteState.isNoteSelected == true
                                        ? context.read<NoteCubit>().addNoteToRemovedList(state.notesList[index].id)
                                        : null;
                                    // log(state.selectedNotestoDeleteList.map((e) => e.id).toList().toString());
                                  },
                                  child: ListTileNoteComponent(
                                    note: state.notesList[index],
                                  ),
                                );
                              },
                            ));
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: CustomFloatinActionButton(
          backgroundcolor: Colors.amber,
          icon: Icons.add,
          iconcolor: Colors.black,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const NewNoteScreen(),
              ),
            );
          },
        ));
  }
}
