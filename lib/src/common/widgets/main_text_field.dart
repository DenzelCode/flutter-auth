import 'package:flutter/material.dart';

class MainTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String label;
  final TextEditingController? controller;
  final int? maxLength;
  final bool? obscureText;

  const MainTextField({
    Key? key,
    this.onChanged,
    this.controller,
    this.maxLength,
    this.obscureText,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(0, 0, 0, 0.1),
        border: OutlineInputBorder(),
        hintText: label,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(25),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(25),
        ),
        contentPadding: EdgeInsets.all(21),
      ),
      obscureText: obscureText ?? false,
      controller: controller,
      onChanged: onChanged,
    );
  }
}
