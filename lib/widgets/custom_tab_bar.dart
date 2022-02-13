import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget with PreferredSizeWidget {
  const CustomTabBar({
    Key? key,
    required this.controller,
    required this.title,
    required this.firstHeadLine,
    required this.secondHeadLine,
  }) : super(key: key);

  final TabController controller;
  final String firstHeadLine;
  final String secondHeadLine;
  final String title;


  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: 0,
      bottom: TabBar(
        indicatorColor: Colors.white,
        controller: controller,
        tabs: [
          Tab(
            text: firstHeadLine,
          ),
          Tab(
            text: secondHeadLine,
          ),
        ],
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(100);
}
