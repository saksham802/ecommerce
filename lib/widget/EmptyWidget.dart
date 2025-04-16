import 'package:ecommerce/innerscreen/FeedPage.dart';
import 'package:ecommerce/screens/bottombar.dart';
import 'package:ecommerce/widget/FeedWidget.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/darkthemeprovider.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  }) : super(key: key);

  final String imagePath, title, subtitle, buttonText;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                imagePath,
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * 0.4,
              ),
              const SizedBox(height: 10),
              const Text(
                'Whoops!',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Textwidget(text: title, color: Colors.cyan, textSize: 20),
              const SizedBox(height: 20),
              Textwidget(text: subtitle, color: Colors.cyan, textSize: 20),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: color),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNav()),
                  );
                },
                child: Textwidget(
                  text: buttonText,
                  textSize: 20,
                  color: themeState.getDarkTheme
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  isTitle: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
