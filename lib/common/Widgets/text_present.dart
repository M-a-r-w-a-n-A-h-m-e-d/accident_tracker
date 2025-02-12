import 'package:flutter/material.dart';

Widget textPresent(
    {required BuildContext context,
    required String mainText,
    required String subText,
    Widget? icon}) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border(
              bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          child: Center(
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon ?? Container(),
                Text(
                  mainText,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            subText,
            style: TextStyle(
              fontSize: 18.0,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      ],
    ),
  );
}
