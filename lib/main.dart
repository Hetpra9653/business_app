import 'package:business_app/features/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:business_app/features/presentation/pages/Dashboard/OwnerDashboardScreen.dart';
import 'package:business_app/features/presentation/pages/login/login_page.dart';
import 'package:business_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'Businessman App',
      home: BlocProvider(
        create: (context) => AuthBloc(), // Create an instance of AuthBloc
        child:user!= null ? OwnerDashboardScreen (): LoginScreen(),
      ),
    );
  }
}
