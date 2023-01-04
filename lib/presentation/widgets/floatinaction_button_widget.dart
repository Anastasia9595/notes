import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomFloatinActionButton extends StatelessWidget {
  const CustomFloatinActionButton({
    super.key,
    required this.backgroundcolor,
    required this.icon,
    required this.iconcolor,
  });
  final Color backgroundcolor;
  final IconData icon;
  final Color iconcolor;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: backgroundcolor,
      child: Icon(
        icon,
        color: iconcolor,
      ),
    );
  }
}
