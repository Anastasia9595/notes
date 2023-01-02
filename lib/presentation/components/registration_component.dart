import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes_laravel/buisness_logic/signup_cubit/signup_cubit.dart';
import 'package:notes_laravel/presentation/widgets/button_widget.dart';
import 'package:notes_laravel/presentation/widgets/textfield_widget.dart';

import '../../buisness_logic/obscure_cubit/obscure_cubit.dart';
import '../../helpers/constants.dart';
import '../../helpers/utils.dart';

class RegistrationWidget extends StatelessWidget {
  RegistrationWidget({super.key, required this.onClickedSignUp});

  final formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmedPasswordTextController = TextEditingController();
  final VoidCallback onClickedSignUp;
  bool isValid = false;

  void registration(BuildContext context, [bool mounted = true]) async {
    isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      bool result = await context.read<SignupCubit>().signUp(
          email: _emailTextController.text.trim(),
          password: _passwordTextController.text.trim(),
          name: _nameTextController.text.trim(),
          confirmedPassword: _confirmedPasswordTextController.text.trim());
      if (!mounted) {
        return;
      }
      result == false ? Future.delayed(const Duration(seconds: 1), () => Navigator.of(context).pop()) : null;
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColorDark,
      body: SafeArea(
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
                        'Hello',
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
                        'Create Account',
                        style: TextStyle(
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextfieldWidget(
                    suffixIcon: null,
                    autovalidateMode: isValid ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    validator: (name) => Utils.validateName(name),
                    textEditingController: _nameTextController,
                    hintext: 'Name',
                    obscureText: false,
                    icon: const Icon(Icons.person),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // email textfield
                  TextfieldWidget(
                    suffixIcon: null,
                    autovalidateMode: isValid ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    validator: (email) => Utils.validateEmail(email),
                    textEditingController: _emailTextController,
                    hintext: 'Email',
                    obscureText: false,
                    icon: const Icon(Icons.mail),
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
                  const SizedBox(
                    height: 20,
                  ),

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
                        validator: (password) =>
                            Utils.validateConfirmPassword(password, _passwordTextController.text.trim()),
                        autovalidateMode: isValid ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                        textEditingController: _confirmedPasswordTextController,
                        hintext: 'Confirmed Password',
                        obscureText: state.obscureTextfield,
                        icon: const Icon(
                          Icons.security,
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: const Divider(
                              thickness: 1,
                              color: Colors.white,
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
                              thickness: 1,
                              color: Colors.white,
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
                    height: 25,
                  ),

                  //signup  button
                  ButtonWidget(
                    onPressed: () => registration(context),
                    buttonName: 'Sign up',
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // register button
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: '\nSign in',
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
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
