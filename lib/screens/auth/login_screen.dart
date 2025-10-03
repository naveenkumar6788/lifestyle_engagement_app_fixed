import 'package:flutter/material.dart';
import '../../widgets/glass_container.dart';
import 'register_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF0F1724), Color(0xFF1F2937)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
          ),
          Center(
            child: SizedBox(
              width: 420,
              child: GlassContainer(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                    SizedBox(height: 12),
                    TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
                    SizedBox(height: 8),
                    TextField(controller: _password, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
                    if (_error != null) ...[
                      SizedBox(height: 8),
                      Text(_error!, style: TextStyle(color: Colors.redAccent)),
                    ],
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _busy ? null : () async {
                        setState(() { _busy = true; _error = null; });
                        final res = await auth.signIn(_email.text.trim(), _password.text.trim());
                        if (res != null && res['error'] != null) {
                          setState(() { _error = res['error'].toString(); });
                        }
                        setState(() { _busy = false; });
                      },
                      child: _busy ? CircularProgressIndicator() : Text('Sign in'),
                      style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(48)),
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegisterScreen())),
                      child: Text('Create account'),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
