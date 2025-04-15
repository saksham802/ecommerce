import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/encrypt/EncryptionMethod.dart';

import 'package:ecommerce/screens/Orders/OrderScreen.dart';
import 'package:ecommerce/screens/Viewed/RecentViewed.dart';
import 'package:ecommerce/screens/Wishlist/Wishlist_Screen.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../auth/loginpage.dart';
import '../auth/registerPage.dart';
import '../theme/darkthemeprovider.dart';
import 'package:encrypt/encrypt.dart' as enc;

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _addressController = TextEditingController();

  String? _email;
  String? _name;
  String? address;
  String? en_email;
  String? en_name;
  String? en_address;
  String? keyString;
  enc.Key? _aesKey;
  bool _isLoading = false;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });

    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      String _uid = user!.uid;
      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(_uid).get();

      if (!userDoc.exists) return;

      en_email = userDoc.get('email');
      en_name = userDoc.get('name');
      en_address = userDoc.get('shipping-address');



        final decryptedName = await EncryptionMethod.decryptData(en_name!);
        final decryptedEmail = await EncryptionMethod.decryptData(en_email!);
        final decryptedaddress = await EncryptionMethod.decryptData(en_address!);
        setState(() {
          _name = decryptedName;
          _email = decryptedEmail;
          address = decryptedaddress; // You can also decrypt this if it was encrypted
        });

    } catch (error) {
      print("Error fetching user data: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            RichText(
              text: TextSpan(
                text: "Hi, ",
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: _name ?? 'user',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            Textwidget(
              text: _email ?? 'Email',
              color: color,
              textSize: 19,
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 2),
            const SizedBox(height: 20),
            _Listtile(
              title: "Address",
              icn: IconlyBold.home,
              onPressed: () {},
              subtitle: address,
              color: color,
            ),
            _Listtile(
              title: "Orders",
              icn: Icons.gif_box,
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>OrdersScreen())),
              color: color,
            ),
            _Listtile(
              title: "Wishlist",
              icn: IconlyBold.heart,
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const WishlistScreen())),
              color: color,
            ),
            _Listtile(
              title: "Viewed",
              icn: Icons.remove_red_eye_outlined,
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const Recentviewed())),
              color: color,
            ),
            _Listtile(
              title: "Forget Password",
              icn: IconlyBold.password,
              onPressed: () {}, // Add reset logic if needed
              color: color,
            ),
            _Listtile(
              title: user == null ? "Login" : "Logout",
              icn: user == null ? IconlyBold.login : IconlyBold.logout,
              onPressed: () async {
                if (user == null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LoginScreen()));
                } else {
                  await _showLogoutDialogBox(context);
                }
              },
              color: color,
            ),
            SwitchListTile(
              title: Textwidget(
                text:
                themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
                color: color,
                textSize: 18,
              ),
              secondary: Icon(themeState.getDarkTheme
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded),
              onChanged: (value) {
                setState(() {
                  themeState.setDarkTheme = value;
                });
              },
              value: themeState.getDarkTheme,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLogoutDialogBox(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Do you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  Widget _Listtile({
    required String title,
    required IconData icn,
    required VoidCallback onPressed,
    String? subtitle,
    required Color color,
  }) {
    return ListTile(
      leading: Icon(icn, color: color),
      title: Textwidget(text: title, color: color, textSize: 20),
      subtitle: Text(subtitle ?? "", style: TextStyle(color: color)),
      trailing: Icon(IconlyLight.arrowRight2, color: color),
      onTap: onPressed,
    );
  }
}
