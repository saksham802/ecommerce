import 'package:card_swiper/card_swiper.dart';
import 'package:ecommerce/auth/forgetpass.dart';
import 'package:ecommerce/auth/googlebtn.dart';
import 'package:ecommerce/auth/registerPage.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter/gestures.dart';

import 'AuthButton.dart'; // Ensure this file and class exist

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passTextController = TextEditingController();
  final FocusNode _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscuredText = true;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
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
            duration: 800,
            autoplayDelay: 5000,
            loop: true,
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(
                offerImages[index],
                fit: BoxFit.cover,
              );
            },
            autoplay: true,
            itemCount: offerImages.length,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120),
                  Textwidget(
                    text: "Welcome Back",
                    color: Colors.white,
                    textSize: 30,
                    isTitle: true,
                  ),
                  Textwidget(
                    text: "Sign in to Continue",
                    color: Colors.white,
                    textSize: 20,
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Field
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          controller: _emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(_passFocusNode);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Password Field
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _obscuredText = !_obscuredText;
                                });
                              },
                              child: Icon(
                                _obscuredText ? IconlyBroken.hide : IconlyBroken.show,
                                color: Colors.white,
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          controller: _passTextController,
                          obscureText: _obscuredText,
                          keyboardType: TextInputType.visiblePassword,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty || value.length < 7) {
                              return 'Please enter a valid password (min 7 chars)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Forgot Password
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPasswordScreen()));},
                            child: const Text(
                              'Forget password?',
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Login Button
                        AuthButton(
                          fct: () {},
                          buttonText: 'Login',
                        ),
                        const SizedBox(height: 10),

                        // Google Sign-in Button
                        GoogleBTN(),
                        const SizedBox(height: 10),

                        // OR Divider
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Colors.white,
                                thickness: 2,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Textwidget(
                              text: 'OR',
                              color: Colors.white,
                              textSize: 18,
                            ),
                            const SizedBox(width: 5),
                            const Expanded(
                              child: Divider(
                                color: Colors.white,
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Guest Login
                        AuthButton(
                          fct: () {},
                          buttonText: 'Continue as a guest',
                          primary: Colors.black,
                        ),
                        const SizedBox(height: 10),

                        // Sign-up Prompt
                        RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account?',
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                            children: [
                              TextSpan(
                                text: '  Sign up',
                                style: const TextStyle(
                                    color: Colors.lightBlue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
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
          ),
        ],
      ),
    );
  }
}
