import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notification/store/firebase_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late FirebaseStore _firebaseStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _firebaseStore = Provider.of<FirebaseStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notification Using FCM'),
        centerTitle: true,
      ),
      body: Observer(
        builder: (context){
          return SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround ,
                  children:  [
                    Flexible(
                      child: Text("Designed by LinhVQ.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    SizedBox(height: 30),
                    Flexible(
                      child: Text("${_firebaseStore.tokenDevice ?? ""}",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15)),
                    )


                  ],
                )
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()  {
          Clipboard.setData(ClipboardData(text: _firebaseStore.tokenDevice ?? ""));
        },
        icon: const Icon(Icons.token),
        label: const Text("Copy Token"),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
