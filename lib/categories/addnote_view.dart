import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/views/Home_view.dart';
import 'package:my_app/widgets/Custom%20button.dart';
import 'package:my_app/widgets/lCustomtextfield_body.dart';

class AddCatedory extends StatefulWidget {
  const AddCatedory({super.key});

  @override
  State<AddCatedory> createState() => _AddCatedoryState();
}

class _AddCatedoryState extends State<AddCatedory> {
  TextEditingController titlecontroller = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  CollectionReference notes = FirebaseFirestore.instance.collection('notes');
  AddNote() async {
    try {
      if (formstate.currentState!.validate()) {
        DocumentReference response =
            await notes.add({"name": titlecontroller.text});
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeView()));
      }
    } catch (e) {
      print('Error$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: Form(
          key: formstate,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: CustomTextField(
                    hinttext: 'EnterName',
                    labeltext: 'Name',
                    controller: titlecontroller,
                    validator: (val) {
                      if (val == "") {
                        return 'Cant be Empty';
                      }
                    }),
              ),
              CustomButton(
                text: 'Add',
                onPressed: () {
                  AddNote();
                },
              )
            ],
          )),
    );
  }
}
