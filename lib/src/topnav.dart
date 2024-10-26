import 'package:apps/src/customColor.dart';
import 'package:flutter/material.dart';

class Topnav extends StatelessWidget {
  final String title;
  final bool showBackButton;

  const Topnav({
    super.key,
    required this.title,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.BiruPrimary,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'OdorMeanChey',
        ),
      ),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
    );
  }
}
