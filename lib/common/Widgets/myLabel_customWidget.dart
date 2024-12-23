import 'package:flutter/material.dart';

Widget MyLabel({
  required BuildContext context,
  required String msg,
  required VoidCallback onTap,
  Color? color,
  required IconData icon,
  TextStyle? msgStyle,
}) {
  final screenWidth = MediaQuery.of(context).size.width;

  double horizontalPadding =
      screenWidth > 600 ? 24.0 : 16.0;
  double fontSize =
      screenWidth > 600 ? 18.0 : 14.0;

  return Container(
    margin: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onPrimary,
      borderRadius: BorderRadius.circular(11.0),
    ),
    child: ListTile(
      onTap: onTap,
      tileColor: Theme.of(context).colorScheme.surface,
      contentPadding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 6.0),
      leading: Icon(icon),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            msg,
            style: msgStyle ??
                TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: fontSize,
                ),
          ),
          const Spacer(),
        ],
      ),
    ),
  );
}
