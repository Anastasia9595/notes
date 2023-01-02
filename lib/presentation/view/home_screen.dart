import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_laravel/buisness_logic/signup_cubit/signup_cubit.dart';

import '../../buisness_logic/login_cubit/login_cubit.dart';
import 'mobile/authentication_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Scaffold(
      appBar: AppBar(
        leading: BlocBuilder<SignupCubit, SignupState>(
          builder: (context, signupstate) {
            return BlocBuilder<LoginCubit, LoginState>(
              builder: (context, signinstate) {
                return IconButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ));
                      if (signupstate.user.isNotEmpty) {
                        context.read<SignupCubit>().signOut(token: signupstate.user.token);
                      } else {
                        final result = await context.read<LoginCubit>().signOut(token: signinstate.user.token);

                        if (result) {
                          if (!mounted) return;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const MobileAuthenticationScreen(),
                            ),
                          );
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Logout failed'),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.arrow_back));
              },
            );
          },
        ),
        title: const Text('Home'),
      ),
      body: Center(
        child: BlocBuilder<SignupCubit, SignupState>(
          builder: (context, signupState) {
            return BlocBuilder<LoginCubit, LoginState>(
              builder: (context, signinState) {
                return Text('Hallo ${signinState.user.isNotEmpty ? signinState.user.name : signupState.user.name}');
              },
            );
          },
        ),
      ),
    );
  }
}
