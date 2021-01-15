import 'package:flutter/material.dart';
import 'package:opinionat/components/text_field_container.dart';

import '../constants.dart';

class RoundedInputField extends StatelessWidget {
  final String text, errorMsg;
  final TextEditingController controller;
  final bool isPassword;
  final IconData icon, suffixIcon;
  final ValueChanged<String> onChanged;
  final TextInputType type;
  final Function validator;


  const RoundedInputField({
    Key key,
    this.text, this.isPassword = false,
    this.icon = Icons.person, this.suffixIcon,
    this.onChanged, this.type, this.controller, 
    this.errorMsg, this.validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        keyboardType: type,

        obscureText: isPassword,
        validator: validator != null ? 
        validator
        :(value) {
          if (value.isEmpty) { 
            return errorMsg; 
          } 
            return null; 
        },
      decoration: 
        InputDecoration(
          hintText: text,
          icon: Icon(icon, color: kPrimaryColor),
          suffixIcon: Icon(suffixIcon, color: kPrimaryColor),
          border: InputBorder.none
        ),
      ),
    );
  }
}
