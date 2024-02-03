import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/views/Home_view.dart';
import 'package:my_app/views/register_view.dart';
import 'package:my_app/widgets/Custom%20button.dart';
import 'package:my_app/widgets/custom%20main%20_text.dart';
import 'package:my_app/widgets/customtext%20button.dart';
import 'package:my_app/widgets/lCustomtextfield_body.dart';
import 'package:my_app/widgets/sub%20text.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  bool isLoading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    isLoading = true;
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeView()));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? Center(
              child: const CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  Form(
                    key: formstate,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                        ),
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[200],
                            ),
                            child: Image.asset(
                              'assets/logo.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        const CustomMainText(
                          text: 'Login',
                        ),
                        const SubText(text: 'Login to continue using the app'),
                        const SizedBox(
                          height: 32,
                        ),
                        CustomTextField(
                          validator: (val) {
                            if (val == "") {
                              return "This field is required";
                            }
                            return null;
                          },
                          controller: email,
                          hinttext: 'Enter your Email',
                          labeltext: 'Email',
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        CustomTextField(
                            validator: (val) {
                              if (val == "") {
                                return "This field is required";
                              }
                              return null;
                            },
                            controller: password,
                            hinttext: 'Enter your password',
                            labeltext: 'password'),
                        InkWell(
                          onTap: () async {
                            if (email.text == "") {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'Please enter an Email',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              )..show();
                              return;
                            }
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Reset Password',
                                desc:
                                    'Please check your email for resting your password',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              )..show();
                            } catch (e) {
                              print(e);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Email',
                                desc: 'No user is logging in with this Email',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              )..show();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 5),
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.topRight,
                            child: Text('Forget password?'),
                          ),
                        ),
                        CustomButton(
                          text: 'Login',
                          onPressed: () async {
                            if (formstate.currentState!.validate()) {
                              try {
                                final credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text,
                                );
                                isLoading = true;
                                setState(() {});
                                if (credential.user!.emailVerified) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeView()));
                                } else {
                                  FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification();
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: 'You must verfy your email',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {},
                                  )..show();
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  print('No user found for that email.');
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: 'No user found for that email.',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {},
                                  )..show();
                                } else if (e.code == 'wrong-password') {
                                  print(
                                      'Wrong password provided for that user.');
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc:
                                        'wrong password provided for that user.',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {},
                                  )..show();
                                }
                              }
                            } else {
                              print('Cant be login');
                            }
                          },
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        const Center(
                          child: Text(
                            '________________________OR________________________',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Center(
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.orange),
                            onPressed: () {
                              signInWithGoogle();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Center(
                                  child: Text(
                                    'Sign in with google',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  'assets/grommet-icons_google.png',
                                  width: 20,
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        CustomTextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterView()));
                            },
                            text: 'Donot have an account ?',
                            text2: 'Register')
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
