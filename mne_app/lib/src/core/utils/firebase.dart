import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseInit {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final dbRef = FirebaseFirestore.instance;
  static final firebase_storage.Reference storageRef =
      firebase_storage.FirebaseStorage.instance.ref();
}
