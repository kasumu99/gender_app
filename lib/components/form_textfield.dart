import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final String labelText;
  final Function(String)? onChanged;
  final int? maxLength;
  final bool? obsecureText;
  final Widget? suffixIcon;

  FormTextField({
    required this.inputType,
    this.validator,
    required this.labelText,
    this.onChanged,
    this.maxLength,
    this.obsecureText = false,
    this.suffixIcon
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
      child: TextFormField(
        decoration:  InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: suffixIcon,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.black
                )
            ),
            labelText: labelText,
            labelStyle: TextStyle(
                color: Colors.black
            )
        ),
        keyboardType: inputType,
        validator: validator,
        textInputAction: TextInputAction.next,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        onChanged: onChanged,
        maxLength: maxLength,
        obscureText: obsecureText!,
      ),
    );
  }
}
