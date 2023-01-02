import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes_laravel/presentation/widgets/button_widget.dart';
import 'package:notes_laravel/presentation/widgets/textfield_widget.dart';

import '../../helpers/constants.dart';
import '../../helpers/utils.dart';

class ResetPasswordWidget extends StatelessWidget {
  ResetPasswordWidget({super.key, required this.onClickedSignIn});

  final formKey = GlobalKey<FormState>();

  bool isValid = false;
  final _emailTextController = TextEditingController();
  final VoidCallback onClickedSignIn;

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
                const Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
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

                //sign in button

                const SizedBox(
                  height: 20,
                ),

                // register button
                ButtonWidget(
                  onPressed: () {},
                  buttonName: 'Reset Password',
                ),
                const SizedBox(
                  height: 20,
                ),

                const SizedBox(
                  height: 15,
                ),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Go back to Sign In',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            onClickedSignIn();
                          },
                        style: const TextStyle(
                          height: 1.5,
                          color: kTextButtonColor,
                          fontSize: 16,
                        ),
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
    );
  }
}
