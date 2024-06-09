// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField(
      {super.key,
      required this.hintText,
      required this.mycontroller,
      this.validator,
      required this.obscureText,
      required this.suffixIcon});
  final String hintText;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: TextFormField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        obscureText: obscureText,
        validator: validator,
        controller: mycontroller,
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffB5D5BC), width: 1.5),
            ),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            fillColor: Color(0xffEEF9F0),
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 17,
              color: Color(0xff928FA6),
              fontWeight: FontWeight.w400,
            )),
      ),
    );
  }
}
