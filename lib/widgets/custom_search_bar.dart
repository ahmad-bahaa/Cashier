import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {

  // final TextEditingController searchController;
  final String hintText;
  final Function(String)? onChanged;

  const CustomSearchBar(
      {required this.hintText, required this.onChanged, Key? key})
      : super(
          key: key,
        );
  // final primaryColor = const Color(0xff4338CA);
  final primaryColor = Colors.blue;
  //final secondaryColor = const Color(0xff6D28D9);
  final secondaryColor = Colors.lightBlue;
  final accentColor = const Color(0xffffffff);
  final backgroundColor = const Color(0xffffffff);
  final errorColor = const Color(0xffEF4444);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [primaryColor, secondaryColor]),
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          boxShadow: [
            BoxShadow(
                offset: const Offset(12, 26),
                blurRadius: 50,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.1)),
          ]),
      child: TextField(
        // controller: searchController,
        textAlign: TextAlign.center,
        onChanged: onChanged,
        style: TextStyle(fontSize: 14, color: accentColor),
        decoration: InputDecoration(
          // prefixIcon: Icon(Icons.email),
          prefixIcon: Icon(Icons.search, size: 20, color: accentColor),
          filled: true,
          fillColor: Colors.transparent,
          hintText: hintText,
          hintStyle: TextStyle(color: accentColor.withOpacity(.75)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}
