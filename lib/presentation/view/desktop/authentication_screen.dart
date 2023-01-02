import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_laravel/presentation/view/desktop/home_screen.dart';
import 'package:notes_laravel/presentation/view/mobile/home_screen.dart';
import 'package:notes_laravel/presentation/view/responsive_home_screen.dart';
import 'package:notes_laravel/presentation/view/tablet/home_screen.dart';

import '../../../buisness_logic/login_cubit/login_cubit.dart';
import '../../../buisness_logic/signup_cubit/signup_cubit.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/utils.dart';
import '../../components/authentication_component.dart';

class DesktopAuthenticationScreen extends StatelessWidget {
  const DesktopAuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColorDark,
      body: MultiBlocListener(
        listeners: [
          BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.isSubmitting == LoginStatus.success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResponsiveHomeScreen(
                        mobileHomeScreen: MobileHomeScreen(),
                        tabletHomeScreen: TabletHomeScreen(),
                        desktopHomeScreen: DesktopHomeScreen()),
                  ),
                );
              } else if (state.isSubmitting == LoginStatus.failed) {
                Utils.showSnackbar(
                  'Invalid Credentials',
                );
              } else if (state.isSubmitting == LoginStatus.falseData) {
                Utils.showSnackbar(
                  'User not exist!',
                );
              } else if (state.isSubmitting == LoginStatus.falsePassword) {
                Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    Utils.showSnackbar(
                      'User data are incorrect',
                    );
                  },
                );
              }
            },
          ),
          BlocListener<SignupCubit, SignupState>(
            listener: (context, state) {
              if (state.isSubmitting == SignupStatus.sucess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DesktopHomeScreen(),
                  ),
                );
              } else if (state.isSubmitting == SignupStatus.userexist) {
                Utils.showSnackbar(
                  'User already exist!',
                );
              } else if (state.isSubmitting == SignupStatus.failed) {
                Utils.showSnackbar(
                  'User not created!',
                );
              }
            },
          ),
        ],
        child: Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 60,
                      ),
                    )
                  ],
                )),
            Container(
              padding: const EdgeInsets.all(60),
              width: MediaQuery.of(context).size.width * 0.5,
              child: const AuthenticationWidget(),
            )
          ],
        ),
      ),
    );
  }
}
