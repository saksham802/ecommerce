import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../innerscreen/CategoryScreen.dart';
import '../theme/darkthemeprovider.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.title,
    required this.image,
    required this.passedColor,
  });

  final String title;
  final String image;
  final Color passedColor;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;

    return SizedBox(
      width: 300,
      height: 300,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            CategoryProductsScreen.routeName,
            arguments: title,
          );
        },
        child: Card(
          elevation: 6,
          shadowColor: passedColor.withOpacity(0.5),
          color: passedColor.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: passedColor, width: 1.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
