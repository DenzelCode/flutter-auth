import 'package:flutter/material.dart';

class MainTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final String label;
  final TextEditingController? controller;
  final bool passwordField;
  final bool emailField;
  final bool messageField;
  final bool usernameField;
  final Color? textColor;

  const MainTextField({
    Key? key,
    this.onChanged,
    this.controller,
    this.onEditingComplete,
    this.onSubmitted,
    this.passwordField = false,
    this.emailField = false,
    this.messageField = false,
    this.usernameField = false,
    this.textColor,
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
        hintStyle: TextStyle(color: textColor),
      ),
      keyboardType: emailField
          ? TextInputType.emailAddress
          : messageField
              ? TextInputType.multiline
              : null,
      obscureText: passwordField,
      maxLength: passwordField ? 60 : null,
      autocorrect: !usernameField && !emailField,
      controller: controller,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      cursorColor: Color.fromRGBO(0, 0, 0, 0.1),
      style: TextStyle(color: textColor),
      maxLines: this.messageField == true ? null : 1,
      textInputAction: onEditingComplete != null
          ? TextInputAction.next
          : messageField
              ? TextInputAction.newline
              : null,
    );
  }
}
