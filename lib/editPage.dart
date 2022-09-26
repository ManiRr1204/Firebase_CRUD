import 'package:flog_demo_test/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'firestorehelper.dart';

class EditPage extends StatefulWidget {
  final UserModel user;
  const EditPage({required this.user, super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController? userNameController;
  TextEditingController? userAgeController;
  TextEditingController? userisSingle;
  void initState() {
    userNameController = TextEditingController(text: widget.user.name);
    userAgeController = TextEditingController(text: widget.user.age);
    userisSingle = TextEditingController(text: widget.user.isSingle);
    super.initState();
  }

  void dispose() {
    userNameController!.dispose();
    userAgeController!.dispose();
    userisSingle!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: userNameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "UserName"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: userAgeController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Age"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: userisSingle,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Single?"),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                FireStoreHelper.update(
                  UserModel(
                      id: widget.user.id,
                      name: userNameController!.text,
                      age: userAgeController!.text,
                      isSingle: userisSingle!.text),
                ).then((value) {
                  Navigator.pop(context);
                });
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
