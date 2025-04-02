import 'package:ecommerce/screens/Orders/Order_Screen.dart';
import 'package:ecommerce/screens/Viewed/RecentViewed.dart';
import 'package:ecommerce/screens/Wishlist/Wishlist_Screen.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../theme/darkthemeprovider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:10.0),
            child: RichText(
              text: TextSpan(
                text: "Hi, ",
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: "Your Name",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:10.0),
            child: Textwidget(text: "myname@gmail.com", color: color, textSize: 19),
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 2),
          const SizedBox(height: 20),

          _Listtile(
            title: "Address",
            icn: IconlyBold.home,
            onPressed: () async {
              await _showAddressDialogBox(context);
            },
            subtitle: "ABC",
            color: color,
          ),
          _Listtile(title: "Order", icn: Icons.gif_box, onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderScreen()));}, color: color),
          _Listtile(title: "Wishlist", icn: IconlyBold.heart, onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>WishlistScreen()));
          }, color: color),
          _Listtile(title: "Viewed", icn: Icons.remove_red_eye_outlined, onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Recentviewed()));
          }, color: color),
          _Listtile(title: "Forget Password", icn: IconlyBold.password, onPressed: () {}, color: color),
          _Listtile(
            title: "Logout",
            icn: IconlyBold.logout,
            onPressed: () async {
              await _showLogoutDialogBox(context);
            },
            color: color,
          ),
          SwitchListTile(
            title: Textwidget(
              text: themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
              color: color,
              textSize: 18,
            ),
            secondary: Icon(
              themeState.getDarkTheme ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            ),
            onChanged: (bool value) {
              setState(() {
                themeState.setDarkTheme = value;
              });
            },
            value: themeState.getDarkTheme,
          ),
        ],
      ),
    );
  }
}

Future<void> _showLogoutDialogBox(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Logout"),
      content: const Text("Do you want to Logout?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog (Logout logic can be added here)
          },
          child: const Text("Yes"),
        ),
      ],
    ),
  );
}

Future<void> _showAddressDialogBox(BuildContext context) async {
  TextEditingController addressController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Update Address"),
      content: TextFormField(
        controller: addressController,
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: "Enter Address",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Save the address logic here
            Navigator.pop(context); // Close the dialog after updating
          },
          child: const Text("Update"),
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
    trailing: Icon(IconlyLight.arrowRight2, color: color),
    subtitle: Text(
      subtitle ?? " ",
      style: TextStyle(color: color),
    ),
    onTap: onPressed,
  );
}
