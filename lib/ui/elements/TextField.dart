import 'package:flutter/material.dart';

class TextFieldBuilder extends StatelessWidget {
  final String hint;
  final TextInputType textInputType;
  final bool isObscure;
  final Widget trailingWidget;
  final int maxLines;
  final Widget leadingWidget;
  final bool enabled;
  final String text;
  final int maxCharacters;

  TextFieldBuilder(
      {this.hint,
        this.textInputType = TextInputType.text,
        this.isObscure = false,
        this.trailingWidget,
        this.maxLines = 1,
        this.enabled = true,
        this.leadingWidget,
        this.text,
        this.maxCharacters});

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5.0,
              offset: Offset(0.0, 2.0),
              spreadRadius: 1.0),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      child: TextField(
        maxLength: maxCharacters,
        controller: text != null ? TextEditingController(text: text) : null,
        style: TextStyle(
            color: Theme.of(context).textTheme.headline1.color,
            fontWeight: FontWeight.w500),
        enabled: enabled,
        maxLines: maxLines,
        obscureText: isObscure,
        keyboardType: textInputType,
        decoration: InputDecoration(
          counterText: "",
          contentPadding: _getContentPadding(),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          isDense: true,
          prefixIcon: leadingWidget,
          suffixIcon: trailingWidget,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            borderSide:
            BorderSide(color: Colors.grey.withOpacity(0.8), width: 0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            borderSide:
            BorderSide(color: Colors.grey.withOpacity(0.8), width: 0),
          ),
        ),
      ),
    );
  }

  _getContentPadding() {
    if (leadingWidget != null) {
      return EdgeInsets.only(top: 5.0, left: 10.0, right: 5.0);
    } else if (trailingWidget != null) {
      return EdgeInsets.only(left: 10.0, right: 5.0, top: 5.0, bottom: 5.0);
    } else if (trailingWidget == null && leadingWidget == null) {
      return EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0);
    }

    return null;
  }
}
