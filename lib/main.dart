import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notes_laravel/buisness_logic/login_cubit/login_cubit.dart';
import 'package:notes_laravel/buisness_logic/obscure_cubit/obscure_cubit.dart';
import 'package:notes_laravel/buisness_logic/signup_cubit/signup_cubit.dart';
import 'package:notes_laravel/presentation/view/desktop/authentication_screen.dart';

import 'package:notes_laravel/presentation/view/mobile/authentication_screen.dart';
import 'package:notes_laravel/presentation/view/responsive_authentication_screen.dart';
import 'package:notes_laravel/presentation/view/tablet/authentication_screen.dart';
import 'package:path_provider/path_provider.dart';

import 'buisness_logic/notes_cubit/note_cubit.dart';
import 'buisness_logic/services/auth_repository.dart';
import 'buisness_logic/services/notes_repository.dart';
import 'helpers/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(AuthRepository()),
        ),
        BlocProvider<SignupCubit>(
          create: (context) => SignupCubit(AuthRepository()),
        ),
        BlocProvider<ObscureCubit>(
          create: (context) => ObscureCubit(),
        ),
        BlocProvider<NoteCubit>(
          create: (context) => NoteCubit(NotesRepository()),
        ),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const ResponsiveLayout(
            mobileScreen: MobileAuthenticationScreen(),
            tabletScreen: TabletAuthenticationScreen(),
            desktopScreen: DesktopAuthenticationScreen()),
      ),
    );
  }
}
