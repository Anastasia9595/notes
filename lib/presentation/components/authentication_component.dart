import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:notes_laravel/presentation/components/login_component.dart';
import 'package:notes_laravel/presentation/components/registration_component.dart';
import 'package:notes_laravel/presentation/components/resetpassword_component.dart';

class AuthenticationWidget extends StatefulWidget {
  const AuthenticationWidget({super.key});

  @override
  State<AuthenticationWidget> createState() => _AuthenticationWidgetState();
}

class _AuthenticationWidgetState extends State<AuthenticationWidget> {
  bool isLogin = true;
  bool forgotPassword = false;
  @override
  Widget build(BuildContext context) {
    if (forgotPassword) {
      return ResetPasswordWidget(onClickedSignIn: toggleForgotPassword);
    } else {
      return isLogin
          ? LoginWidget(onClickedSignUp: toggle, onClickedForgotPassword: toggleForgotPassword)
          : RegistrationWidget(onClickedSignUp: toggle);
    }
  }

  void toggle() => setState(() => isLogin = !isLogin);
  void toggleForgotPassword() => setState(() => forgotPassword = !forgotPassword);
}
