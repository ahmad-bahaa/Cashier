import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
   const CustomBottomAppBar({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);
  final String buttonText;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: BottomAppBar(
        // color: Colors.white,
        child: Container(
          height: 70,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: onPressed,
                child: Text(
                  buttonText,
                  style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white),
                ),
            ),
          ),
        ),
      ),
    );
  }
}
