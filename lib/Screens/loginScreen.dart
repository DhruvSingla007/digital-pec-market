import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_major/Screens/authScreen.dart';
import 'package:user_major/Screens/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/buttons.dart';
import '../Widgets/error_dialog.dart';
import '../Widgets/loading_dialog.dart';
import '../Widgets/textFormFields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // To change the visibility of password field
  bool isObscure = true;

  Future<void> _login() async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingDialog(
          message: "Checking Credentials",
        );
      },
    );
    User? currentUser;

    await firebaseAuth
        .signInWithEmailAndPassword(
      email: _emailController.text.toString().trim(),
      password: _passwordController.text.toString().trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: error.message.toString().trim(),
          );
        },
      );
    });

    if (currentUser != null) {
      _readDataAndSetDataLocally(currentUser!);
    }
    // } else {
    //   Navigator.pop(context);
    //   showDialog(
    //     context: context,
    //     builder: (c) {
    //       return ErrorDialog(
    //         message: "Login Failed. Please try again.",
    //       );
    //     },
    //   );
    // }
  }

  Future<void> _readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        SharedPreferences? sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString("userUID", currentUser.uid);
        await sharedPreferences.setString(
            "userName", snapshot.data()!["userName"]);
        await sharedPreferences.setString(
            "userEmail", currentUser.email.toString());


        List<String> userCartList = snapshot.data()!['userCart'].cast<String>();
        await sharedPreferences.setStringList("userCart", userCartList);

        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      } else {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const AuthScreen()));

        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "No record found.",
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          Form(
            key: _loginFormKey,
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      "images/login.png",
                      height: 275,
                      width: 275,
                    ),
                  ),
                ),
                Center(
                  child: formFields(
                    isObscure: false,
                    errorMessage: "Please enter your email ID",
                    hintText: "Email ID",
                    editingController: _emailController,
                    preIcon: const Icon(Icons.mail),
                  ),
                ),
                Center(
                  child: formFields(
                    isObscure: isObscure,
                    suffixIconButton: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      icon: isObscure
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                    errorMessage: "Please enter your password",
                    hintText: "Password",
                    editingController: _passwordController,
                    preIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                buttons(
                  function: () {
                    if (_loginFormKey.currentState!.validate()) {
                      _login();
                    } else {
                      print("Not validated");
                    }
                  },
                  widget: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
