import 'package:cashier/widgets/single_unit.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;


class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('المساعدة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SingleUnit(text: 'اتصل بنا على', width: 400, isBold: false),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                child: const Text(
                  '+201556533914',
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                ),
                onTap: () => UrlLauncher.launch("tel://+201556533914"),
              ),
              // const SingleUnit(text: '03/0553434201', width: 400, isBold: true),
              const SizedBox(
                height: 50,
              ),
              const SingleUnit(
                  text: 'تواصل معنا على', width: 400, isBold: false),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                child: const Text(
                  'Facebook/FreeCashier',
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                ),
                onTap: () => UrlLauncher.launch('https://www.facebook.com/freecashier/'),
              ),
              const SizedBox(
                height: 10,
              ),
              // const SingleUnit(
              //     text: 'Instagram @Cashier', width: 4000, isBold: false),
              // const SizedBox(
              //   height: 10,
              // ),
              // const SingleUnit(
              //     text: 'Youtube.com/Cashier', width: 4000, isBold: false),
            ],
          ),
        ),
      ),
    );
  }
}
