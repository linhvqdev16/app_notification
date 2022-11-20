import 'package:mobx/mobx.dart';

part 'firebase_store.g.dart';

class FirebaseStore = FirebaseStoreAbstract with _$FirebaseStore;

 abstract class FirebaseStoreAbstract with Store{

  // late Repository _repository;

  @observable
  String? tokenDevice;

  @action
  void setTokenDevice(String? token){
   tokenDevice = token;
   print(tokenDevice);
  }

 }