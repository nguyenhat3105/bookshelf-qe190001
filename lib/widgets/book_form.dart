import 'package:flutter/material.dart';

import '../models/book.dart';
import '../theme/app_theme.dart';
import 'app_widgets.dart';

class BookForm extends StatefulWidget {
  const BookForm({
    required this.submitText,
    required this.onSubmit,
    super.key,
    this.initial,
    this.onCancel,
  });
  final String submitText;
  final Book? initial;
  final Future<void> Function(String, String, String, String, int?, String)
  onSubmit;
  final VoidCallback? onCancel;
  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final key = GlobalKey<FormState>();
  late final TextEditingController title, author, rating, notes;
  String? genre, status;
  bool submitted = false, busy = false;
  String? error;
  @override
  void initState() {
    super.initState();
    final b = widget.initial;
    title = TextEditingController(text: b?.title);
    author = TextEditingController(text: b?.author);
    rating = TextEditingController(text: b?.rating?.toString());
    notes = TextEditingController(text: b?.notes);
    genre = b?.genre;
    status = b?.status;
  }

  @override
  void dispose() {
    title.dispose();
    author.dispose();
    rating.dispose();
    notes.dispose();
    super.dispose();
  }

  String? requiredMax(String? v, String name, int max) {
    if (v == null || v.trim().isEmpty) return '$name is required';
    if (v.trim().length > max) return '$name must be at most $max characters';
    return null;
  }

  Future<void> submit() async {
    setState(() => submitted = true);
    if (!(key.currentState?.validate() ?? false)) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await widget.onSubmit(
        title.text.trim(),
        author.text.trim(),
        genre!,
        status!,
        rating.text.trim().isEmpty ? null : int.parse(rating.text.trim()),
        notes.text.trim(),
      );
      if (widget.initial == null) {
        key.currentState!.reset();
        title.clear();
        author.clear();
        rating.clear();
        notes.clear();
        setState(() {
          genre = null;
          status = null;
          submitted = false;
        });
      }
    } catch (e) {
      setState(() => error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Form(
    key: key,
    autovalidateMode: submitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled,
    child: Column(
      children: [
        LabeledField(
          label: 'Title',
          child: TextFormField(
            controller: title,
            decoration: const InputDecoration(hintText: 'Enter book title'),
            validator: (v) => requiredMax(v, 'Title', 100),
          ),
        ),
        const SizedBox(height: 16),
        LabeledField(
          label: 'Author',
          child: TextFormField(
            controller: author,
            decoration: const InputDecoration(hintText: 'Enter author name'),
            validator: (v) => requiredMax(v, 'Author', 60),
          ),
        ),
        const SizedBox(height: 16),
        LabeledField(
          label: 'Genre',
          child: DropdownButtonFormField<String>(
            initialValue: genre,
            decoration: const InputDecoration(hintText: 'Choose genre'),
            items: [
              'Fiction',
              'Non-Fiction',
              'Academic',
              'Other',
            ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (v) => setState(() => genre = v),
            validator: (v) => v == null ? 'Please choose a genre' : null,
          ),
        ),
        const SizedBox(height: 16),
        LabeledField(
          label: 'Status',
          child: DropdownButtonFormField<String>(
            initialValue: status,
            decoration: const InputDecoration(hintText: 'Choose status'),
            items: [
              'To Read',
              'Reading',
              'Finished',
            ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (v) => setState(() => status = v),
            validator: (v) => v == null ? 'Please choose a status' : null,
          ),
        ),
        const SizedBox(height: 16),
        LabeledField(
          label: 'Rating (optional)',
          child: TextFormField(
            controller: rating,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: '0 to 5'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return null;
              final n = int.tryParse(v.trim());
              return n == null || n < 0 || n > 5
                  ? 'Rating must be a whole number from 0 to 5'
                  : null;
            },
          ),
        ),
        const SizedBox(height: 16),
        LabeledField(
          label: 'Notes (optional)',
          child: TextFormField(
            controller: notes,
            minLines: 4,
            maxLines: 6,
            decoration: const InputDecoration(hintText: 'Add a short note'),
            validator: (v) => (v?.length ?? 0) > 300
                ? 'Notes must be at most 300 characters'
                : null,
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 12),
          Text(error!, style: const TextStyle(color: AppColors.error700)),
        ],
        const SizedBox(height: 20),
        if (widget.onCancel == null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: busy ? null : submit,
              child: Text(busy ? 'Please wait...' : widget.submitText),
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: busy ? null : widget.onCancel,
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: busy ? null : submit,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
