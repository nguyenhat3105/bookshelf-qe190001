import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/book_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_states.dart';
import '../widgets/app_widgets.dart';
import '../widgets/book_form.dart';
import 'detail_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final service = BookService(), search = TextEditingController();
  String genre = 'All', status = 'All';
  bool favorites = false, showAdd = true;
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  List<Book> filtered(List<Book> all) {
    final q = search.text.trim().toLowerCase();
    final b = all
        .where(
          (x) =>
              (genre == 'All' || x.genre == genre) &&
              (status == 'All' || x.status == status) &&
              (!favorites || x.favorite) &&
              (q.isEmpty ||
                  x.title.toLowerCase().contains(q) ||
                  x.author.toLowerCase().contains(q)),
        )
        .toList();
    b.sort((a, c) {
      final t = a.title.toLowerCase().compareTo(c.title.toLowerCase());
      return t != 0
          ? t
          : a.author.toLowerCase().compareTo(c.author.toLowerCase());
    });
    return b;
  }

  void clear() {
    search.clear();
    setState(() {
      genre = 'All';
      status = 'All';
      favorites = false;
    });
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Book>>(
          stream: service.watchBooks(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2.5),
              );
            final books = filtered(snapshot.data!);
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'BookShelf',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary900,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => FirebaseAuth.instance.signOut(),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                        Text(
                          'Signed in as ${FirebaseAuth.instance.currentUser?.email ?? ''}',
                          style: const TextStyle(color: AppColors.neutral600),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'My library',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 16),
                        AppCard(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () => setState(() => showAdd = !showAdd),
                                child: Row(
                                  children: [
                                    Text(
                                      'Add a book',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const Spacer(),
                                    Icon(
                                      showAdd
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                    ),
                                  ],
                                ),
                              ),
                              if (showAdd) ...[
                                const SizedBox(height: 20),
                                BookForm(
                                  submitText: 'Add Book',
                                  onSubmit: (t, a, g, s, r, n) async {
                                    await service.addBook(
                                      title: t,
                                      author: a,
                                      genre: g,
                                      status: s,
                                      rating: r,
                                      notes: n,
                                    );
                                    if (context.mounted)
                                      showSuccess(context, 'Book added');
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _Filters(
                          search: search,
                          genre: genre,
                          status: status,
                          favorites: favorites,
                          onChanged: () => setState(() {}),
                          onGenre: (v) => setState(() => genre = v),
                          onStatus: (v) => setState(() => status = v),
                          onFavorite: (v) => setState(() => favorites = v),
                          onClear: clear,
                        ),
                        const SizedBox(height: 16),
                        _Summary(books),
                        const SizedBox(height: 20),
                        Text(
                          'Books',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                if (books.isEmpty)
                  const SliverToBoxAdapter(child: EmptyState())
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    sliver: SliverList.separated(
                      itemCount: books.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => BookCard(
                        book: books[i],
                        onFavorite: () => service.toggleFavorite(books[i]),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(bookId: books[i].id),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.search,
    required this.genre,
    required this.status,
    required this.favorites,
    required this.onChanged,
    required this.onGenre,
    required this.onStatus,
    required this.onFavorite,
    required this.onClear,
  });
  final TextEditingController search;
  final String genre, status;
  final bool favorites;
  final VoidCallback onChanged, onClear;
  final ValueChanged<String> onGenre, onStatus;
  final ValueChanged<bool> onFavorite;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Filter and search',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            TextButton(onPressed: onClear, child: const Text('Clear')),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: search,
          onChanged: (_) => onChanged(),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search by title or author',
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: genre,
          decoration: const InputDecoration(labelText: 'Genre'),
          items: [
            'All',
            'Fiction',
            'Non-Fiction',
            'Academic',
            'Other',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => onGenre(v!),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: status,
          decoration: const InputDecoration(labelText: 'Status'),
          items: [
            'All',
            'To Read',
            'Reading',
            'Finished',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => onStatus(v!),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text(
              'Favorites only',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Switch(
              value: favorites,
              activeTrackColor: AppColors.primary500,
              onChanged: onFavorite,
            ),
          ],
        ),
      ],
    ),
  );
}

class _Summary extends StatelessWidget {
  const _Summary(this.books);
  final List<Book> books;
  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final b in books) counts[b.status] = (counts[b.status] ?? 0) + 1;
    final order = {'To Read': 0, 'Reading': 1, 'Finished': 2};
    final rows = counts.entries.toList()
      ..sort((a, b) {
        final c = b.value.compareTo(a.value);
        return c != 0 ? c : (order[a.key]!).compareTo(order[b.key]!);
      });
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Books: ${books.length}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 24),
              Text(
                'Favorites: ${books.where((b) => b.favorite).length}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (rows.isNotEmpty) const Divider(height: 24),
          ...rows.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  StatusChip(e.key),
                  const Spacer(),
                  Text(
                    '${e.value}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
