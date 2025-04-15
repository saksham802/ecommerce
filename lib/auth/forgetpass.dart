import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widget/textwidget.dart';
import 'AuthButton.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgetPasswordScreen';
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailTextController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  Future<void> _forgetPassFCT() async {
    final email = _emailTextController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showError('Please enter a valid email address.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
          msg: "Email is sent Kindly Check",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Something went wrong');
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> offerImages = [
      'assets/Offer1.jpg',
      'assets/Offer2.jpg',
      'assets/Offer3.jpg',
      'assets/Offer4.jpg'
    ];

    return Scaffold(
      body: Stack(
        children: [
          Swiper(
            itemBuilder: (context, index) => Image.asset(
              offerImages[index],
              fit: BoxFit.cover,
            ),
            autoplay: true,
            itemCount: offerImages.length,
          ),
          Container(color: Colors.black.withOpacity(0.7)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.pop(context),
                  child: const Icon(IconlyLight.arrowLeft2, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Textwidget(
                  text: 'Forget password',
                  color: Colors.white,
                  textSize: 30,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailTextController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Email address',
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                AuthButton(
                  buttonText: _isLoading ? 'Please wait...' : 'Reset now',
                  fct: _isLoading ? null : _forgetPassFCT,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
