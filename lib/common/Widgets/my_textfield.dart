import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final Icon prefixIcon;

  const MyTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.prefixIcon,
    required this.label,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          isDense: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purple,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          fillColor: Theme.of(context).colorScheme.onPrimary,
          filled: true,
          hintText: widget.label,
          prefixIcon: widget.prefixIcon,
          prefixIconColor: Colors.purple,
          hintStyle: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}



Widget MyLabel({
  required BuildContext context,
  required String msg,
  required VoidCallback onTap,
  Color? color,
  required IconData icon,
  TextStyle? msgStyle,
}) {
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
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      leading: Icon(icon),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            msg,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          const Spacer(),
        ],
      ),
    ),
  );
}
