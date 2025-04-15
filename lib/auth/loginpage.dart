import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/auth/forgetpass.dart';
import 'package:ecommerce/auth/googlebtn.dart';
import 'package:ecommerce/auth/registerPage.dart';
import 'package:ecommerce/encrypt/EncryptionMethod.dart';
import 'package:ecommerce/screens/bottombar.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter/gestures.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'AuthButton.dart';

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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loginUsingGoogle(context) async{
    final googlesignIn=GoogleSignIn();
    final googleAccount= await GoogleSignIn().signIn();
    if(googleAccount!=null){
      final googleAuth= await googleAccount.authentication;
     if(googleAuth.idToken!=null&&googleAuth.accessToken!=null){
       try{
         await authInstance.signInWithCredential(GoogleAuthProvider.credential(
           idToken: googleAuth.idToken,
           accessToken: googleAuth.accessToken
         ));
         Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNav()));
       } on FirebaseAuthException catch(error){
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(error.message ?? 'Login failed')),
         );
       }finally{

       }
     }
    }
  }

  Future<void> _loginUser() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTextController.text.trim(),
        password: _passTextController.text.trim(),
      );

      final user = userCredential.user;
      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data()!;
          final base64Key = data['key'];
          final base64Iv = data['iv'];
          final encryptedName = data['encryptedName'];

          final key = enc.Key.fromBase64(base64Key);
          final iv = enc.IV.fromBase64(base64Iv);
          EncryptionMethod.keyEnc=key;
          EncryptionMethod.vi=iv;

          // Store or use decryptedName as needed
        }

      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Login failed')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
          Container(color: Colors.black.withOpacity(0.7)),
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
                          focusNode: _passFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.length < 7) {
                              return 'Password must be at least 7 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordScreen()));
                            },
                            child: const Text(
                              'Forget password?',
                              style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        AuthButton(
                          fct: _isLoading ? null : _loginUser,
                          buttonText: _isLoading ? 'Loading...' : 'Login',
                        ),
                        const SizedBox(height: 10),
                        InkWell(onTap: (){
                          _loginUsingGoogle(context);
                        },child: GoogleBTN()),
                        const SizedBox(height: 10),
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
                        AuthButton(
                          fct: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const BottomNav()),
                            );
                          },
                          buttonText: 'Continue as a guest',
                          primary: Colors.black,
                        ),
                        const SizedBox(height: 10),
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
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
