import 'package:flutter/material.dart';

import '../models/book.dart';
import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.neutral200),
    ),
    child: child,
  );
}

class LabeledField extends StatelessWidget {
  const LabeledField({required this.label, required this.child, super.key});
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral800,
        ),
      ),
      const SizedBox(height: 8),
      child,
    ],
  );
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.controller,
    required this.hint,
    required this.validator,
    super.key,
  });
  final TextEditingController controller;
  final String hint;
  final String? Function(String?) validator;
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool hidden = true;
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    obscureText: hidden,
    validator: widget.validator,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      hintText: widget.hint,
      suffixIcon: IconButton(
        tooltip: hidden ? 'Show password' : 'Hide password',
        onPressed: () => setState(() => hidden = !hidden),
        icon: Icon(
          hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
      ),
    ),
  );
}

class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});
  final String status;
  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      'Reading' => (AppColors.warning100, AppColors.warning700),
      'Finished' => (AppColors.success100, AppColors.success700),
      _ => (AppColors.info100, AppColors.info700),
    };
    return _Chip(status, bg, fg);
  }
}

class GenreChip extends StatelessWidget {
  const GenreChip(this.genre, {super.key});
  final String genre;
  @override
  Widget build(BuildContext context) =>
      _Chip(genre, AppColors.neutral100, AppColors.neutral700);
}

class _Chip extends StatelessWidget {
  const _Chip(this.text, this.bg, this.fg);
  final String text;
  final Color bg, fg;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
    ),
  );
}

class BookCard extends StatelessWidget {
  const BookCard({
    required this.book,
    required this.onTap,
    required this.onFavorite,
    super.key,
  });
  final Book book;
  final VoidCallback onTap, onFavorite;
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: onTap,
    child: AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Toggle favorite',
                onPressed: onFavorite,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    book.favorite
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    key: ValueKey(book.favorite),
                    color: book.favorite
                        ? AppColors.accent500
                        : AppColors.neutral500,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          Text(
            book.author,
            style: const TextStyle(fontSize: 13, color: AppColors.neutral600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GenreChip(book.genre),
              const SizedBox(width: 8),
              StatusChip(book.status),
              const Spacer(),
              const Text(
                'View',
                style: TextStyle(
                  color: AppColors.primary700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.primary700,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void showSuccess(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
      ),
    );
