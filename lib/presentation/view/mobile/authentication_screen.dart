import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_laravel/buisness_logic/login_cubit/login_cubit.dart';
import 'package:notes_laravel/buisness_logic/signup_cubit/signup_cubit.dart';
import 'package:notes_laravel/helpers/constants.dart';
import 'package:notes_laravel/helpers/utils.dart';
import 'package:notes_laravel/presentation/components/authentication_component.dart';
import 'package:notes_laravel/presentation/view/desktop/home_screen.dart';
import 'package:notes_laravel/presentation/view/home_screen.dart';
import 'package:notes_laravel/presentation/view/mobile/home_screen.dart';
import 'package:notes_laravel/presentation/view/responsive_home_screen.dart';
import 'package:notes_laravel/presentation/view/tablet/home_screen.dart';

import '../../../buisness_logic/notes_cubit/note_cubit.dart';

class MobileAuthenticationScreen extends StatelessWidget {
  const MobileAuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColorDark,
        body: MultiBlocListener(
          listeners: [
            BlocListener<LoginCubit, LoginState>(
              listener: (context, loginState) {
                if (loginState.isSubmitting == LoginStatus.success) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ResponsiveHomeScreen(
                          mobileHomeScreen: MobileHomeScreen(),
                          tabletHomeScreen: TabletHomeScreen(),
                          desktopHomeScreen: DesktopHomeScreen()),
                    ),
                  );
                } else if (loginState.isSubmitting == LoginStatus.failed) {
                  Utils.showSnackbar('Login failed');
                } else if (loginState.isSubmitting == LoginStatus.falseData) {
                  Utils.showSnackbar('User not exist!');
                } else if (loginState.isSubmitting == LoginStatus.falsePassword) {
                  Future.delayed(const Duration(seconds: 1), () {
                    Utils.showSnackbar('User data are incorrect');
                  });
                }
              },
            ),
            BlocListener<SignupCubit, SignupState>(listener: (context, registrationState) {
              if (registrationState.isSubmitting == SignupStatus.sucess) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              } else if (registrationState.isSubmitting == SignupStatus.failed) {
                Utils.showSnackbar('Signup failed');
              } else if (registrationState.isSubmitting == SignupStatus.userexist) {
                Utils.showSnackbar('User exist');
              } else if (registrationState.isSubmitting == SignupStatus.logout) {
                log('sign out');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MobileAuthenticationScreen(),
                  ),
                );
              }
            })
          ],
          child: BlocBuilder<SignupCubit, SignupState>(
            builder: (context, signupState) {
              return BlocBuilder<LoginCubit, LoginState>(
                builder: (context, signinState) {
                  // if (signinState.isSubmitting == LoginStatus.success ||
                  //     signupState.isSubmitting == SignupStatus.sucess) {
                  //   return const MobileHomeScreen();
                  // }
                  return const AuthenticationWidget();
                },
              );
            },
          ),
        ));
  }
}
