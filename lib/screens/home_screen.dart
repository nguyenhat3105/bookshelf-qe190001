import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'auth_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  void open(BuildContext c, bool register) => Navigator.push(
    c,
    MaterialPageRoute(builder: (_) => AuthScreen(register: register)),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    'BookShelf',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary900,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => open(context, false),
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () => open(context, true),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary050, Color(0xFFE8F0ED)],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'YOUR PERSONAL LIBRARY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.primary700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'BookShelf',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Keep every book you own or want to read organized in one calm, private place.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: AppColors.neutral600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => open(context, true),
                      child: const Text('Register'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => open(context, false),
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Everything in its place',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  const _Feature(
                    Icons.library_books_outlined,
                    'Track your books',
                    'Keep a private library that follows you across sessions.',
                  ),
                  const SizedBox(height: 12),
                  const _Feature(
                    Icons.sort_outlined,
                    'Sort by status',
                    'See what is next, in progress, or already finished.',
                  ),
                  const SizedBox(height: 12),
                  const _Feature(
                    Icons.star_outline_rounded,
                    'Rate your favorites',
                    'Save ratings, notes, and favorites for every title.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Feature extends StatelessWidget {
  const _Feature(this.icon, this.title, this.description);
  final IconData icon;
  final String title, description;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary700, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: AppColors.neutral600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
