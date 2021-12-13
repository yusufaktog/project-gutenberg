import 'book_card.dart';

class User {
  String name;
  String password;
  List<Book> bookShelf = [];

  User({required this.name, required this.password});
}
