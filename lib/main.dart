import 'package:crypto_app/rooter.dart';
import 'package:crypto_app/services/authorization_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());   
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthorizationService>(
      create: (_) => AuthorizationService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Crypto App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Rooter(),
      ),
    );
  }
}
