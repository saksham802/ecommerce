import 'package:ecommerce/FetchScreen.dart';
import 'package:ecommerce/Provider/CartProvider.dart';
import 'package:ecommerce/Provider/ProductProvider.dart';
import 'package:ecommerce/Provider/WishListProvider.dart';
import 'package:ecommerce/auth/loginpage.dart';
import 'package:ecommerce/screens/Orders/OrderScreen.dart';
import 'package:ecommerce/screens/bottombar.dart';
import 'package:ecommerce/screens/home.dart';

import 'package:ecommerce/theme/darkthemeprovider.dart';
import 'package:ecommerce/theme/themedata.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/OrderProvider.dart';
import 'innerscreen/CategoryScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
    await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('An error occurred'),
              ),
            ),
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ProductProvider()),
            ChangeNotifierProvider(create: (_) => themeChangeProvider),
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => WishlistProvider()),
            ChangeNotifierProvider(create: (_) => OrdersProvider())
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme:
                Styles.themeData(themeProvider.getDarkTheme, context),
                home: FetchScreen(),
                routes: {
                  CategoryProductsScreen.routeName: (context) =>
                  const CategoryProductsScreen(),
                },
              );
            },
          ),
        );
      },
    );
  }
}
