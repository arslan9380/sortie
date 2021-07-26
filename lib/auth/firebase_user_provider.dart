import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class SortieFirebaseUser {
  SortieFirebaseUser(this.user);
  final User user;
  bool get loggedIn => user != null;
}

SortieFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<SortieFirebaseUser> sortieFirebaseUserStream() => FirebaseAuth.instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<SortieFirebaseUser>((user) => currentUser = SortieFirebaseUser(user));
