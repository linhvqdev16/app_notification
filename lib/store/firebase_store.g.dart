// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FirebaseStore on FirebaseStoreAbstract, Store {
  late final _$tokenDeviceAtom =
      Atom(name: 'FirebaseStoreAbstract.tokenDevice', context: context);

  @override
  String? get tokenDevice {
    _$tokenDeviceAtom.reportRead();
    return super.tokenDevice;
  }

  @override
  set tokenDevice(String? value) {
    _$tokenDeviceAtom.reportWrite(value, super.tokenDevice, () {
      super.tokenDevice = value;
    });
  }

  late final _$FirebaseStoreAbstractActionController =
      ActionController(name: 'FirebaseStoreAbstract', context: context);

  @override
  void setTokenDevice(String? token) {
    final _$actionInfo = _$FirebaseStoreAbstractActionController.startAction(
        name: 'FirebaseStoreAbstract.setTokenDevice');
    try {
      return super.setTokenDevice(token);
    } finally {
      _$FirebaseStoreAbstractActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tokenDevice: ${tokenDevice}
    ''';
  }
}
