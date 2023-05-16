// @dart=2.9
import 'package:flutter/material.dart';

class FormHelper {
  //text input
  static Widget textInput(
    BuildContext context,
    Object initialValue,
    Function onChanged, {
    bool isTextArea = false,
    bool isNumberInput = false,
    obscureText: false,
    Function onValidate,
    Widget prefixIcon,
    Widget suffixIcon,
    bool readOnly = false,
  }) {
    return TextFormField(
      initialValue: initialValue != null ? initialValue.toString() : "",
      decoration: fieldDecoration(
        context,
        "",
        "",
        suffixIcon: suffixIcon,
      ),
      readOnly: readOnly,
      obscureText: obscureText,
      maxLines: !isTextArea ? 1 : 3,
      keyboardType: isNumberInput ? TextInputType.number : TextInputType.text,
      onChanged: (String value) {
        return onChanged(value);
      },
      validator: (value) {
        return onValidate(value);
      },
    );
  }

  static InputDecoration fieldDecoration(
    BuildContext context,
    String hintText,
    String helperText, {
    Widget prefixIcon,
    Widget suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(6),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1,
        ),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1,
        ),
      ),
    );
  }

  static Widget fieldLabel(String labelName) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        labelName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
    );
  }

  static Widget fieldLabelValue(BuildContext context, String labelName) {
    return FormHelper.textInput(
      context,
      labelName,
      (value) => {},
      onValidate: (value) {
        return null;
      },
      readOnly: true,
    );
  }

  static Widget saveButton(String buttonText, Function onTap,
      {String color, String textColor, bool fullWidth}) {
    return SizedBox(
      height: 50.0,
      width: 150,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 34, 182, 69),
              style: BorderStyle.solid,
              width: 1.0,
            ),
            color: const Color.fromARGB(255, 32, 145, 24),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showMessage(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    Function onPressed,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              // ignore: void_checks
              onPressed: () {
                return onPressed();
              },
              child: Text(buttonText),
            )
          ],
        );
      },
    );
  }
}
