import 'package:cashier/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        color: Colors.white,
        child: Container(
          height: 70,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget(buttonText, context),
          ),
        ),
      ),
    );
  }

  List<Widget> widget(String title, BuildContext context) {
    switch (title) {
      case 'cash':
        {
          return [
            button(
                context,
                'استلام نقدية',
                () => Get.to(() => AddCashScreen(
                      isSending: false,
                    ))),
            button(
              context,
              'دفع نقدية',
              () => Get.to(() => AddCashScreen(
                    isSending: true,
                  )),
            ),
          ];
        }
      case 'null':
        {
          return [
            const SizedBox(),
          ];
        }
      default:
        {
          return [button(context, buttonText, onPressed)];
        }
    }
  }

  Padding button(BuildContext context, String text, Function() function) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: function,
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
