import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../book_card.dart';

class DatabaseHelper {
  static void addBook(Book book) async {
    print("Book is being added${book.id}");

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

  static void updateBookmark(String bookId, int bookmark) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final User? user = _firebaseAuth.currentUser;

    String uid = user!.uid;

    await FirebaseFirestore.instance
        .collection("Bookshelves")
        .doc(uid)
        .collection("Bookshelf")
        .doc(bookId)
        .update({"bookmark": bookmark});
  }

  static void removeBook(String bookId) async {
    print("Book is being removed$bookId");
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final User? user = _firebaseAuth.currentUser;

    String uid = user!.uid;

    await FirebaseFirestore.instance
        .collection("Bookshelves")
        .doc(uid)
        .collection("Bookshelf")
        .doc(bookId)
        .delete();
  }

  static Future<bool> bookshelfContains(String bookId) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final User? user = _firebaseAuth.currentUser;
    String uid = user!.uid;

    if (await FirebaseFirestore.instance
        .collection("Bookshelves")
        .doc(uid)
        .collection("Bookshelf")
        .where("id", isEqualTo: bookId)
        .get()
        .then((value) {
      return value.docs.isEmpty;
    })) {
      return false;
    } else {
      return true;
    }
  }
}
