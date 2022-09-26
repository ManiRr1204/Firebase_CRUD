import 'package:flog_demo_test/editPage.dart';
import 'package:flog_demo_test/firestorehelper.dart';
import 'package:flog_demo_test/user_model.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userAgeController = TextEditingController();
  TextEditingController userisSingle = TextEditingController();

  void dispose() {
    userNameController.dispose();
    userAgeController.dispose();
    userisSingle.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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
                print(userNameController.text);
                print(userAgeController.text);
                print(userisSingle.text);
                FireStoreHelper.create(UserModel(
                    name: userNameController.text,
                    age: userAgeController.text,
                    isSingle: userisSingle.text));
              },
              child: const Text("Create"),
            ),
            StreamBuilder(
              stream: FireStoreHelper.read(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Some Error Occured"),
                  );
                }
                if (snapshot.hasData) {
                  final user_data = snapshot.data;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: user_data!.length,
                      itemBuilder: ((context, index) {
                        final single_data = user_data[index];
                        return Container(
                          child: ListTile(
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      title: const Text("Delete"),
                                      content: const Text(
                                          "Are you sure to want to delete?"),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              FireStoreHelper.delete(
                                                  single_data);
                                              Navigator.pop(context);
                                            },
                                            child: const Text("OK")),
                                        ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("CANCEL"))
                                      ],
                                    );
                                  }));
                                  
                            },
                            
                            leading: Container(
                              width: 45,
                              height: 45,
                              decoration: const BoxDecoration(
                                color: Colors.yellow,
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: Text(single_data.isSingle)),
                            ),
                            title: Text(single_data.name),
                            subtitle: Text(single_data.age),
                            trailing: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditPage(
                                        user: UserModel(
                                            id: single_data.id,
                                            name: single_data.name,
                                            age: single_data.age,
                                            isSingle: single_data.isSingle),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit)),
                          ),
                        );
                      }),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  // Future _create() async {
  //   final userCollections = FirebaseFirestore.instance.collection("first_data");
  //   final user_doc = userCollections.doc("New User");

  //   await user_doc.set({
  //     "name": "Ragu",
  //     "age": "24",
  //     "single?": "No",
  //   });
  // }

  // Future _create() async {
  //   final userCollections = FirebaseFirestore.instance.collection("first_data");
  //   final user_doc = userCollections.doc();

  //   await user_doc.set({
  //     "name": userNameController.text.trim(),
  //     "age": userAgeController.text.trim(),
  //     "single?": userisSingle.text.trim(),
  //   });
  // }
}
