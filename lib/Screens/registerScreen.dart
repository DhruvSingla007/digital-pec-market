import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_major/Screens/homeScreen.dart';
import 'package:user_major/Widgets/buttons.dart';
import 'package:user_major/Widgets/textFormFields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/error_dialog.dart';
import '../Widgets/loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _registerFormKey = GlobalKey<FormState>();

  // To change the visibility of password field
  bool isObscure = true;

  Future<void> _formValidation() async {
    String pwd = _passwordController.text.toString().trim();
    String cnfPwd = _confirmPasswordController.text.toString().trim();
    String contactNumber = _contactController.text.toString().trim();

    if (pwd.length < 8) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: "Password must contain minimum 8 characters.",
          );
        },
      );
    } else if (pwd != cnfPwd) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: "Passwords do not match. Please try again",
          );
        },
      );
    } else if (contactNumber.length != 10 ||
        int.tryParse(contactNumber) == null) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: "Please enter a valid contact number",
          );
        },
      );
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return LoadingDialog(
              message: "Registering Account",
            );
          });
      _signupUser();
    }
  }

  Future<void> _saveUser(User currentUser) async {
    // Save the user detail in the firebase

    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
      "userUID": currentUser.uid,
      "userName": _nameController.text.toString().trim(),
      "userContact": _contactController.text.toString().trim(),
      "userEmail": currentUser.email,
      "status": "approved",
      "userCart": ["garbageValue"],
    });

    // Save the user details locally (in the Shared Preferences)
    SharedPreferences? sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString("userUID", currentUser.uid);
    await sharedPreferences.setString(
        "userName", _nameController.text.toString().trim());
    await sharedPreferences.setString(
        "userEmail", currentUser.email.toString());
    await sharedPreferences.setStringList("userCart", ["garbageValue"]);
  }

  Future<void> _signupUser() async {
    User? currentUser;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: _emailController.text.toString().trim(),
      password: _passwordController.text.toString().trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: error.message.toString(),
          );
        },
      );
    });

    if (currentUser != null) {
      _saveUser(currentUser!).then((value) {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (builder) => const HomeScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          Form(
            key: _registerFormKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                // Name
                Center(
                  child: formFields(
                    isObscure: false,
                    errorMessage: "Please enter your name",
                    hintText: "Name",
                    editingController: _nameController,
                    preIcon: const Icon(Icons.account_circle_sharp),
                  ),
                ),

                Center(
                  child: formFields(
                    isObscure: false,
                    errorMessage: "Please enter your contact number",
                    hintText: "Contact",
                    editingController: _contactController,
                    preIcon: const Icon(Icons.phone),
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
                    hintText: "Confirm Password",
                    editingController: _confirmPasswordController,
                    preIcon: const Icon(Icons.lock),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                buttons(
                  function: () {
                    if (_registerFormKey.currentState!.validate()) {
                      _formValidation();
                    } else {
                      print("Not validated");
                    }
                  },
                  widget: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Register",
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
