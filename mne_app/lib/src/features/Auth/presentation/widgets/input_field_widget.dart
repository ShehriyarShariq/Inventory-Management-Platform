import 'package:flutter/material.dart';

class InputFieldWidget extends StatefulWidget {
  final String label, type;
  final bool hasActionButton;
  final TextEditingController controller;

  const InputFieldWidget({
    Key? key,
    required this.label,
    this.type = "text",
    this.hasActionButton = false,
    required this.controller,
  }) : super(key: key);

  @override
  _InputFieldWidgetState createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  bool _isHidden = false;

  @override
  void initState() {
    super.initState();

    _isHidden = widget.type == "password";
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case "text":
        return TextInputType.text;
      case "email":
        return TextInputType.emailAddress;
      case "password":
        return TextInputType.visiblePassword;
      default:
        return TextInputType.text;
    }
  }

  _getActionButtonIcon() {
    switch (widget.type) {
      case "password":
        return _isHidden
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          keyboardType: _getKeyboardType(),
          controller: widget.controller,
          textInputAction: TextInputAction.next,
          obscureText: _isHidden,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(226, 226, 226, 1),
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(226, 226, 226, 1),
              ),
            ),
            labelText: widget.label,
            labelStyle: const TextStyle(
              color: Color.fromRGBO(124, 124, 124, 1),
            ),
            contentPadding: const EdgeInsets.fromLTRB(0, 10, 25, 10),
            isDense: true,
          ),
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
        widget.hasActionButton
            ? Positioned(
                top: 0,
                bottom: 0,
                right: 2,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isHidden = !_isHidden;
                    });
                  },
                  child: Icon(
                    _getActionButtonIcon(),
                    color: const Color.fromRGBO(124, 124, 124, 1),
                    size: 22,
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
