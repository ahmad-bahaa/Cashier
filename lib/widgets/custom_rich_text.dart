import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String discription;
  final String text;
  final Function() onTap;
  const CustomRichText(
      {Key? key,
        required this.discription,
        required this.text,
        required this.onTap})
      : super(key: key);
// "Don't already Have an account? "
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.149,
          top: MediaQuery.of(context).size.height * 0.08),
      child: Text.rich(
        TextSpan(
            text: discription,
            style: const TextStyle(color: Colors.black, fontSize: 18),
            children: [
              TextSpan(
                  text: text,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  recognizer: TapGestureRecognizer()..onTap = onTap),
            ]),
      ),
    );
  }
}