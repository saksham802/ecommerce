import 'package:ecommerce/innerscreen/FeedPage.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/darkthemeprovider.dart';

class Emptyscreen extends StatelessWidget {
  const Emptyscreen({
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
    final bool isDarkTheme = themeState.getDarkTheme;
    final Color textColor = isDarkTheme ? Colors.white : Colors.black;

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
                height: MediaQuery.of(context).size.height * 0.4,
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: textColor),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedsScreen()),
                  );
                },
                child: Textwidget(
                  text: buttonText,
                  textSize: 20,

                  color: textColor,
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
