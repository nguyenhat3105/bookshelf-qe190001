import 'package:bookshelf_app/models/book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('duplicate key ignores case and surrounding spaces', () {
    expect(Book.duplicateKey('  Dune ', ' Frank Herbert '), 'dune--frank-herbert');
    expect(Book.duplicateKey('dune', 'frank herbert'), 'dune--frank-herbert');
  });
}
