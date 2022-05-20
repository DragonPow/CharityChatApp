import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PassWordInput extends StatefulWidget {
  final bool securitytext;
  final Color background;
  final Color boder;
  final String hint;
  final bool ispass;
  final TextEditingController textcontroller;
  final TextInputType textInputType;

  PassWordInput(
      {required this.securitytext,
      required this.background,
      required this.boder,
      required this.hint,
      required this.ispass,
      required this.textcontroller,
      required this.textInputType});

  @override
  _PassWordInputState createState() => _PassWordInputState();
}

class _PassWordInputState extends State<PassWordInput> {
  bool securi = true;

  @override
  void initState() {
    securi = widget.securitytext;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      controller: widget.textcontroller,
      decoration: InputDecoration(
          prefixIcon: Icon(
            widget.ispass ? Icons.lock : Icons.cake_rounded,
            color: cwColorMain,
            size: 23.h,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: widget.boder.withOpacity(1), width: 2)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: widget.boder.withOpacity(1), width: 1)),
          hintText: widget.hint,
          hintStyle:kText15RegularGreyNotetext,
          fillColor: widget.background.withOpacity(0.2),
          filled: true,
          suffixIcon: IconButton(
            icon: widget.ispass
                ? securi
                    ? FaIcon(FontAwesomeIcons.eyeSlash, size: 22.h)
                    : Icon(Icons.remove_red_eye_outlined, size: 25.h)
                : const FaIcon(
                    FontAwesomeIcons.calendar,
                    color: cwColorMain,
                  ),
            color: cwColorBlackIcon,
            onPressed: () {
              widget.ispass
                  ? setState(() {
                      securi = !securi;
                    })
                  : showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 1,
                          DateTime.now().month, DateTime.now().day),
                      lastDate: DateTime(DateTime.now().year + 2),
                    ).then((value) {
                      if (value != null) {
                        if (widget.textcontroller.text !=
                            DateFormat('dd/MM/yyyy').format(value))
                          // ignore: curly_braces_in_flow_control_structures
                          setState(() {
                            widget.textcontroller.text =
                                DateFormat('dd/MM/yyyy').format(value);
                          });
                      }
                    });
            },
            splashRadius: 25,
          )),
      obscureText: widget.ispass ? securi : false,
    );
  }
}
