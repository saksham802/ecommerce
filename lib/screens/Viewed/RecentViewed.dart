import 'package:ecommerce/screens/Viewed/RecentViewWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'package:provider/provider.dart';

import '../../services/Global_Method.dart';
import '../../theme/darkthemeprovider.dart';
import '../../widget/EmptyWidget.dart';
import '../../widget/textwidget.dart';

class ViewedRecentlyScreen extends StatefulWidget {
  static const routeName = '/ViewedRecentlyScreen';

  const ViewedRecentlyScreen({Key? key}) : super(key: key);

  @override
  _ViewedRecentlyScreenState createState() => _ViewedRecentlyScreenState();
}

class _ViewedRecentlyScreenState extends State<ViewedRecentlyScreen> {
  bool check = true;


  Widget backWidget(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isEmpty = true;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    if (_isEmpty == true) {
      return const EmptyScreen(
        title: 'Your history is empty',
        subtitle: 'No products have been viewed yet!',
        buttonText: 'Shop now',
        imagePath: 'assets/history.png',
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                GlobalMethod.warningDialog(
                  title: 'Empty your history?',
                  subtitle: 'Are you sure?',
                  fct: () {},
                  context: context,
                );
              },
              icon: Icon(
                IconlyBroken.delete,
                color: color,
              ),
            ),
          ],
          leading: backWidget(context),
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          title: Textwidget(
            text: 'History',
            color: color,
            textSize: 24.0,
          ),
          backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (ctx, index) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              child: RecentlyViewedWidget(),
            );
          },
        ),
      );
    }
  }
}
