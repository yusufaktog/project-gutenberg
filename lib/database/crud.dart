import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../book_card.dart';

class DatabaseHelper {
  static void addBook(Book book) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final User? user = _firebaseAuth.currentUser;

    String uid = user!.uid;
    if (await bookshelfContains(book.id!)) {
      Fluttertoast.showToast(
          msg: "${book.title} has been already added to your bookshelf\nPLease check out your bookshelf", webPosition: "center", webShowClose: true);
      return;
    }
    await FirebaseFirestore.instance
        .collection("Bookshelves")
        .doc(uid)
        .collection("Bookshelf")
        .doc(book.id)
        .set({"id": book.id, "title": book.title, "author": book.author, "bookmark": book.bookmark, "image_url": book.coverImageUrl}).whenComplete(
            () => Fluttertoast.showToast(msg: "${book.title} has been added to your bookshelf", webPosition: "center", webShowClose: true));
  }

  static void updateBookmark(String bookId, int bookmark) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final User? user = _firebaseAuth.currentUser;

    String uid = user!.uid;

    await FirebaseFirestore.instance.collection("Bookshelves").doc(uid).collection("Bookshelf").doc(bookId).update({"bookmark": bookmark});
  }

  static void removeBook(Book book) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final User? user = _firebaseAuth.currentUser;

    String uid = user!.uid;

    await FirebaseFirestore.instance.collection("Bookshelves").doc(uid).collection("Bookshelf").doc(book.id).delete().whenComplete(
        () => Fluttertoast.showToast(msg: "${book.title} has been removed from your bookshelf", webPosition: "center", webShowClose: true));
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

  static Future<String> getCurrentUserName() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final User? user = _firebaseAuth.currentUser;
    String uid = user!.uid;
    String name = "def";
    await FirebaseFirestore.instance.collection("User").doc(uid).snapshots().forEach((element) {
      name = element["name"];
    });
    return name;
  }
}
