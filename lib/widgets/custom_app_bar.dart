import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  const CustomAppBar({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline4!
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(50);
}
