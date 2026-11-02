import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/book.dart';

class BookService {
  final _books = FirebaseFirestore.instance.collection('books');
  String get uid => FirebaseAuth.instance.currentUser!.uid;
  Stream<List<Book>> watchBooks() => _books
      .where('userId', isEqualTo: uid)
      .snapshots()
      .map((s) => s.docs.map(Book.fromDoc).toList());
  Future<void> addBook({
    required String title,
    required String author,
    required String genre,
    required String status,
    int? rating,
    required String notes,
  }) async {
    final id = '${uid}__${Book.duplicateKey(title, author)}',
        ref = _books.doc(id);
    await FirebaseFirestore.instance.runTransaction((tx) async {
      if ((await tx.get(ref)).exists)
        throw FirebaseException(
          plugin: 'cloud_firestore',
          message: 'This title and author already exist',
        );
      final b = Book(
        id: id,
        userId: uid,
        title: title,
        author: author,
        genre: genre,
        status: status,
        rating: rating,
        favorite: false,
        notes: notes,
      );
      tx.set(ref, b.toMap());
    });
  }

  Future<void> updateBook(Book b) async {
    final newId = '${uid}__${Book.duplicateKey(b.title, b.author)}';
    if (newId == b.id) {
      await _books.doc(b.id).update(b.toMap()..remove('createdAt'));
      return;
    }
    final oldRef = _books.doc(b.id), newRef = _books.doc(newId);
    await FirebaseFirestore.instance.runTransaction((tx) async {
      if ((await tx.get(newRef)).exists)
        throw FirebaseException(
          plugin: 'cloud_firestore',
          message: 'This title and author already exist',
        );
      tx.set(
        newRef,
        Book(
          id: newId,
          userId: b.userId,
          title: b.title,
          author: b.author,
          genre: b.genre,
          status: b.status,
          rating: b.rating,
          favorite: b.favorite,
          notes: b.notes,
          createdAt: b.createdAt,
        ).toMap(),
      );
      tx.delete(oldRef);
    });
  }

  Future<void> toggleFavorite(Book b) =>
      _books.doc(b.id).update({'favorite': !b.favorite});
  Future<void> deleteBook(Book b) => _books.doc(b.id).delete();
}
