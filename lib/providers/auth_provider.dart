import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final _auth = Supabase.instance.client.auth;
  User? user;
  bool isLoading = true;

  AuthProvider() {
    _init();
  }

 Future<void> _init() async {
  final session = _auth.currentSession;
  user = session?.user;

  _auth.onAuthStateChange.listen((authState) {
    user = authState.session?.user;
    isLoading = false;
    notifyListeners();
  });

  isLoading = false;
  notifyListeners();
}


  bool get isLoggedIn => user != null;

  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      final res = await _auth.signInWithPassword(email: email, password: password);
      if (res.user != null) {
        user = res.user;
        notifyListeners();
        return null;
      }
      return {'error': 'Unable to sign in'};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> signUp(String email, String password) async {
    try {
      final res = await _auth.signUp(email: email, password: password);
      if (res.user != null) {
        user = res.user;
        notifyListeners();
        return null;
      }
      return {'error': 'Unable to sign up (check email verification)'};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    user = null;
    notifyListeners();
  }
}
