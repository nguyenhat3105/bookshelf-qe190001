import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/list_screen.dart';
import 'widgets/app_states.dart';

class BookShelfApp extends StatelessWidget {
  const BookShelfApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'BookShelf',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const LoadingState();
        return snapshot.data == null ? const HomeScreen() : const ListScreen();
      },
    ),
  );
}
