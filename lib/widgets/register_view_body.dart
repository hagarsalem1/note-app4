import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/views/login_view.dart';
import 'package:my_app/widgets/Custom%20button.dart';
import 'package:my_app/widgets/custom%20main%20_text.dart';
import 'package:my_app/widgets/customtext%20button.dart';
import 'package:my_app/widgets/lCustomtextfield_body.dart';
import 'package:my_app/widgets/sub%20text.dart';

class RegisterViewBody extends StatefulWidget {
  const RegisterViewBody({super.key});

  @override
  State<RegisterViewBody> createState() => _RegisterViewBodyState();
}

class _RegisterViewBodyState extends State<RegisterViewBody> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
                const CustomMainText(text: 'Register'),
                const SubText(text: 'Regiser to continue using the app'),
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
                    controller: username,
                    hinttext: 'Enter your username',
                    labeltext: 'username'),
                SizedBox(
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
                    labeltext: 'Email'),
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
                    labeltext: 'Password'),
                const SizedBox(
                  height: 32,
                ),
                const SizedBox(
                  height: 32,
                ),
                CustomButton(
                  text: 'Register',
                  onPressed: () async {
                    if (formstate.currentState!.validate()) {
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );
                        FirebaseAuth.instance.currentUser!
                            .sendEmailVerification();

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginView()));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'error',
                            desc: 'The password provided is too weak.',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {},
                          )..show();
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'error',
                            desc: 'The account already exists for that email.',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {},
                          ).show();
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      print('Canot be Register');
                    }
                  },
                ),
                const SizedBox(
                  height: 32,
                ),
                CustomTextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginView()));
                    },
                    text: 'Already have an account?',
                    text2: 'Login')
              ],
            ),
          )
        ],
      ),
    ));
  }
}
