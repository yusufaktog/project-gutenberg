import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../book_card.dart';

class DatabaseHelper {
  static void addBook(Book book) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final User? user = _firebaseAuth.currentUser;

    String uid = user!.uid;

    await FirebaseFirestore.instance
        .collection("Bookshelves")
        .doc(uid)
        .collection("Bookshelf")
        .doc(book.id)
        .set({
      "id": book.id,
      "title": book.title,
      "author": book.author,
      "bookmark": book.bookmark,
      "image_url": book.coverImageUrl
    });
  }

  static void updateBookmark(String id, int bookmark) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final User? user = _firebaseAuth.currentUser;

    String uid = user!.uid;

    await FirebaseFirestore.instance
        .collection("Bookshelves")
        .doc(uid)
        .collection("Bookshelf")
        .doc(id)
        .update({"bookmark": bookmark});
  }
}
