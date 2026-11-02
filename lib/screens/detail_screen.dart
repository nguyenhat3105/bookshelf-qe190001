import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/book_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_states.dart';
import '../widgets/app_widgets.dart';
import '../widgets/book_form.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({required this.bookId, super.key});
  final String bookId;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final service = BookService();
  bool editing = false;
  Future<void> delete(Book b) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete book?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error700,
            ),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (yes == true) {
      await service.deleteBook(b);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) =>
      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('books')
            .doc(widget.bookId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LoadingState();
          if (!snapshot.data!.exists)
            return const Scaffold(body: Center(child: Text('Book not found')));
          final b = Book.fromDoc(snapshot.data!);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text('Book details'),
              actions: [
                if (!editing)
                  TextButton(
                    onPressed: () => setState(() => editing = true),
                    child: const Text('Edit'),
                  ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: editing
                    ? _Edit(
                        book: b,
                        onCancel: () => setState(() => editing = false),
                        onSave: (updated) async {
                          await service.updateBook(updated);
                          if (mounted) {
                            setState(() => editing = false);
                            showSuccess(context, 'Book updated');
                          }
                        },
                      )
                    : _View(
                        book: b,
                        onFavorite: () => service.toggleFavorite(b),
                        onDelete: () => delete(b),
                      ),
              ),
            ),
          );
        },
      );
}

class _View extends StatelessWidget {
  const _View({
    required this.book,
    required this.onFavorite,
    required this.onDelete,
  });
  final Book book;
  final VoidCallback onFavorite, onDelete;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(book.title, style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 4),
      Text(
        book.author,
        style: const TextStyle(fontSize: 16, color: AppColors.neutral600),
      ),
      const SizedBox(height: 20),
      AppCard(
        child: Column(
          children: [
            _Row('Genre', GenreChip(book.genre)),
            const Divider(height: 24),
            _Row('Status', StatusChip(book.status)),
            const Divider(height: 24),
            _Row(
              'Rating',
              Text(book.rating == null ? 'Not rated' : '${book.rating} / 5'),
            ),
            const Divider(height: 24),
            _Row(
              'Favorite',
              IconButton(
                tooltip: 'Toggle favorite',
                onPressed: onFavorite,
                icon: Icon(
                  book.favorite
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: book.favorite
                      ? AppColors.accent500
                      : AppColors.neutral500,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notes', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              book.notes.isEmpty ? 'No notes' : book.notes,
              style: const TextStyle(color: AppColors.neutral700, height: 1.5),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error700),
          onPressed: onDelete,
          child: const Text('Delete'),
        ),
      ),
    ],
  );
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label;
  final Widget value;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(label, style: const TextStyle(color: AppColors.neutral600)),
      const Spacer(),
      value,
    ],
  );
}

class _Edit extends StatelessWidget {
  const _Edit({
    required this.book,
    required this.onCancel,
    required this.onSave,
  });
  final Book book;
  final VoidCallback onCancel;
  final Future<void> Function(Book) onSave;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Edit book', style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 20),
      AppCard(
        child: BookForm(
          initial: book,
          submitText: 'Save',
          onCancel: onCancel,
          onSubmit: (t, a, g, s, r, n) => onSave(
            Book(
              id: book.id,
              userId: book.userId,
              title: t,
              author: a,
              genre: g,
              status: s,
              rating: r,
              favorite: book.favorite,
              notes: n,
              createdAt: book.createdAt,
            ),
          ),
        ),
      ),
    ],
  );
}
