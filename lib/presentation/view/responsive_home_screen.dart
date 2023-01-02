import 'package:flutter/material.dart';

class ResponsiveHomeScreen extends StatelessWidget {
  const ResponsiveHomeScreen({
    super.key,
    required this.mobileHomeScreen,
    required this.tabletHomeScreen,
    required this.desktopHomeScreen,
  });

  final Widget mobileHomeScreen;
  final Widget tabletHomeScreen;
  final Widget desktopHomeScreen;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return desktopHomeScreen;
      } else if (constraints.maxWidth > 600) {
        return tabletHomeScreen;
      } else {
        return mobileHomeScreen;
      }
    });
  }
}
