import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'src/core/utils/firebase.dart';
import 'injection_container.dart' as di;

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
