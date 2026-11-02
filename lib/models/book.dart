import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  const Book({
    required this.id,
    required this.userId,
    required this.title,
    required this.author,
    required this.genre,
    required this.status,
    this.rating,
    required this.favorite,
    required this.notes,
    this.createdAt,
  });
  final String id, userId, title, author, genre, status, notes;
  final int? rating;
  final bool favorite;
  final Timestamp? createdAt;
  factory Book.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Book(
      id: doc.id,
      userId: d['userId'] ?? '',
      title: d['title'] ?? '',
      author: d['author'] ?? '',
      genre: d['genre'] ?? '',
      status: d['status'] ?? '',
      rating: (d['rating'] as num?)?.toInt(),
      favorite: d['favorite'] ?? false,
      notes: d['notes'] ?? '',
      createdAt: d['createdAt'] as Timestamp?,
    );
  }
  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'title': title.trim(),
    'author': author.trim(),
    'genre': genre,
    'status': status,
    'rating': rating,
    'favorite': favorite,
    'notes': notes.trim(),
    'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    'duplicateKey': duplicateKey(title, author),
  };
  static String duplicateKey(String title, String author) {
    String clean(String v) => v
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return '${clean(title)}--${clean(author)}';
  }
}
