import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: AppColors.primary700,
      ),
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(top: 48),
    child: Column(
      children: [
        Icon(Icons.menu_book_outlined, size: 48, color: AppColors.neutral400),
        SizedBox(height: 12),
        Text(
          'No books found',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4),
        Text(
          'Try adjusting your filters or add a new book.',
          style: TextStyle(color: AppColors.neutral600),
        ),
      ],
    ),
  );
}

class InlineError extends StatelessWidget {
  const InlineError(this.message, {super.key});
  final String message;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.error100,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.error_outline, color: AppColors.error700, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: AppColors.error700),
          ),
        ),
      ],
    ),
  );
}
