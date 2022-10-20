import 'package:flutter/material.dart';
import '../../app_styles.dart';

class MyTextFormField extends StatefulWidget {
  const MyTextFormField({
    Key? key,
    required this.hint,
    required this.icon,
    required this.fillColor,
    required this.inputType,
    required this.inputAction,
    required this.focusNode,
    required this.validator,
    required this.controller,
  }) : super(key: key);

  final String hint;
  final IconData icon;
  final Color fillColor;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final FocusNode focusNode;
  final String? Function(String?) validator;
  final TextEditingController controller;

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: widget.controller,
        style: widget.focusNode.hasFocus
            ? kBodyText2.copyWith(color: kPrimaryColor)
            : kInputHintStyle,
        cursorColor: kSecondaryColor,
        keyboardType: widget.inputType,
        textInputAction: widget.inputAction,
        focusNode: widget.focusNode,
        validator: widget.validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor,
          border: kInputBorder,
          enabledBorder: kInputBorder,
          hintText: widget.hint,
          hintStyle: kInputHintStyle,
          // contentPadding: EdgeInsets.all(0),
          // since we removed container remove content padding 0 to enable default padding for the field
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              // height: 60,
              // this container height is causing the error
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 2,
                    color: kScaffoldBackground,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  widget.icon,
                  color: widget.focusNode.hasFocus
                      ? kPrimaryColor
                      : kSecondaryColor.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
