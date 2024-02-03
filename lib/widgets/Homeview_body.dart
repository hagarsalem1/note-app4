import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/categories/addnote_view.dart';
import 'package:my_app/views/Home_view.dart';
import 'package:my_app/views/login_view.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;
  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('notes').get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddCatedory()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('HomePage '),
        actions: [
          IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                try {
                  googleSignIn.signOut();
                } catch (e) {
                  print(e);
                }
                await FirebaseAuth.instance.signOut();

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginView()));
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 160),
              itemBuilder: (context, index) {
                return InkWell(
                  onLongPress: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'Warnning',
                      desc: 'You are going to delete this item',
                      btnCancelOnPress: () {
                        print('cancel');
                      },
                      btnOkOnPress: () async {
                        await FirebaseFirestore.instance
                            .collection('notes')
                            .doc(data[index].id)
                            .delete();
                        print('ok');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeView()));
                      },
                    )..show();
                  },
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icons8-folder-48.png',
                            height: 100,
                          ),
                          Text('${data[index]['name']}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
