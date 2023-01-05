import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes_laravel/buisness_logic/login_cubit/login_cubit.dart';
import 'package:notes_laravel/buisness_logic/obscure_cubit/obscure_cubit.dart';
import 'package:notes_laravel/presentation/widgets/button_widget.dart';
import 'package:notes_laravel/presentation/widgets/textfield_widget.dart';

import '../../buisness_logic/notes_cubit/note_cubit.dart';
import '../../helpers/constants.dart';
import '../../helpers/utils.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({
    Key? key,
    required this.onClickedSignUp,
    required this.onClickedForgotPassword,
  }) : super(key: key);
  final VoidCallback onClickedSignUp;
  final VoidCallback onClickedForgotPassword;

  final formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();

  final _passwordTextController = TextEditingController();

  bool isValid = false;
  bool showdialog = false;

  void login(BuildContext context, [bool mounted = true]) async {
    isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      bool result = await context
          .read<LoginCubit>()
          .signIn(email: _emailTextController.text.trim(), password: _passwordTextController.text.trim());
      String token = context.read<LoginCubit>().state.user.token;
      context.read<NoteCubit>().getAllNotes(token);
      log(result.toString());
      if (!mounted) {
        return;
      }
      result == false ? Future.delayed(const Duration(milliseconds: 500), () => Navigator.of(context).pop()) : null;
    } catch (e) {
      log('Error in login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // greeting
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: const FittedBox(
                    child: Text(
                      'Hello Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                  child: FittedBox(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 26,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                const SizedBox(
                  height: 50,
                ),
                // email textfield
                TextfieldWidget(
                  suffixIcon: null,
                  validator: (email) => Utils.validateEmail(email),
                  autovalidateMode: isValid ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                  textEditingController: _emailTextController,
                  hintext: 'Email',
                  obscureText: false,
                  icon: const Icon(
                    Icons.mail,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // password textfield

                BlocBuilder<ObscureCubit, ObscureState>(
                  builder: (context, state) {
                    return TextfieldWidget(
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.obscureTextfield ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          context.read<ObscureCubit>().toggleObscure();
                        },
                      ),
                      validator: (password) => Utils.validatePassword(password),
                      autovalidateMode: isValid ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                      textEditingController: _passwordTextController,
                      hintext: 'Password',
                      obscureText: state.obscureTextfield,
                      icon: const Icon(
                        Icons.security,
                      ),
                    );
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 30, top: 10),
                      child: TextButton(
                          onPressed: onClickedForgotPassword,
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: kTextButtonColor),
                          )),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                          child: const Divider(
                            color: Colors.white,
                            thickness: 1,
                            height: 36,
                          )),
                    ),
                    const Text(
                      "OR",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: const Divider(
                            color: Colors.white,
                            thickness: 1,
                            height: 36,
                          )),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/google.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/facebook.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 35,
                        width: 35,
                        child: SvgPicture.asset('assets/github.svg'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                // register button
                ButtonWidget(
                  onPressed: () => login(context),
                  buttonName: 'Sign in',
                ),
                const SizedBox(
                  height: 25,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: '\nSign up',
                        style: const TextStyle(
                          color: kTextButtonColor,
                          fontSize: 16,
                          height: 1.8,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            onClickedSignUp();
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
