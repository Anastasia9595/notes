import 'package:flutter/material.dart';

class CustomFloatinActionButton extends StatelessWidget {
  const CustomFloatinActionButton({
    super.key,
    required this.backgroundcolor,
    required this.icon,
    required this.iconcolor,
    required this.onPressed,
  });
  final Color backgroundcolor;
  final IconData icon;
  final Color iconcolor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onPressed(),
      backgroundColor: backgroundcolor,
      child: Icon(
        icon,
        color: iconcolor,
      ),
    );
  }
}
