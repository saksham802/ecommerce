import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/encrypt/EncryptionMethod.dart';
import 'package:ecommerce/screens/bottombar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../theme/darkthemeprovider.dart';
import '../widget/LoadingManager.dart';
import '../widget/textwidget.dart';
import 'AuthButton.dart';
import 'package:encrypt/encrypt.dart' as enc;

final FirebaseAuth authInstance = FirebaseAuth.instance;

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  bool _obscureText = true;


  @override
  void dispose() {
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _addressTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnRegister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await authInstance.createUserWithEmailAndPassword(
        email: _emailTextController.text.toLowerCase().trim(),
        password: _passTextController.text.trim(),
      );

      final User? user = authInstance.currentUser;
      final _uid = user!.uid;


      final enc.Key key = await EncryptionMethod.generateAesKey();
      final enc.IV iv = enc.IV.fromSecureRandom(16);
      EncryptionMethod.keyEnc = key;
      EncryptionMethod.vi = iv;

      final keyString = key.base64;
      final ivString = iv.base64;

      // Encrypt fields
      final encName = await EncryptionMethod.encryptData(_fullNameController.text);
      final encEmail = await EncryptionMethod.encryptData(_emailTextController.text);
      final encAddress = await EncryptionMethod.encryptData(_addressTextController.text);

      await FirebaseFirestore.instance.collection('users').doc(_uid).set({
        'id': _uid,
        'name': encName,
        'email': encEmail,
        'shipping-address': encAddress,
        'userWish': [],
        'userCart': [],
        'createdAt': Timestamp.now(),
        'key': keyString,
        'iv': ivString,
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(' FirebaseAuthException: ${error.code} - ${error.message}');
      _showErrorDialog(error.message ?? 'Registration failed');
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('💥 General error: $error');
      _showErrorDialog('An error occurred. Please try again later.');
    }
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registration Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
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
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;

    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: <Widget>[
            Swiper(
              duration: 800,
              autoplayDelay: 6000,
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  offerImages[index],
                  fit: BoxFit.cover,
                );
              },
              autoplay: true,
              itemCount: offerImages.length,
            ),
            Container(color: Colors.black.withOpacity(0.7)),
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 60.0),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.canPop(context)
                        ? Navigator.pop(context)
                        : null,
                    child: Icon(
                      IconlyLight.arrowLeft2,
                      color: isDark ? Colors.white : Colors.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Textwidget(
                    text: 'Welcome',
                    color: Colors.white,
                    textSize: 30,
                    isTitle: true,
                  ),
                  const SizedBox(height: 8),
                  Textwidget(
                    text: "Sign up to continue",
                    color: Colors.white,
                    textSize: 18,
                    isTitle: false,
                  ),
                  const SizedBox(height: 30.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_emailFocusNode),
                          keyboardType: TextInputType.name,
                          controller: _fullNameController,
                          validator: (value) =>
                          value!.isEmpty ? "This Field is missing" : null,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('Full name'),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          validator: (value) =>
                          value!.isEmpty || !value.contains("@")
                              ? "Please enter a valid Email address"
                              : null,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('Email'),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          focusNode: _passFocusNode,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passTextController,
                          validator: (value) =>
                          value!.isEmpty || value.length < 7
                              ? "Please enter a valid password"
                              : null,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_addressFocusNode),
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('Password').copyWith(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          focusNode: _addressFocusNode,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: _submitFormOnRegister,
                          controller: _addressTextController,
                          validator: (value) =>
                          value!.isEmpty || value.length < 10
                              ? "Please enter a valid address"
                              : null,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          decoration: _inputDecoration('Shipping address'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {

                      },
                      child: const Text(
                        'Forget password?',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  AuthButton(
                    buttonText: 'Sign up',
                    fct: _submitFormOnRegister,
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Already a user?',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Sign in',
                          style:
                          const TextStyle(color: Colors.lightBlue, fontSize: 18),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
    );
  }
}
