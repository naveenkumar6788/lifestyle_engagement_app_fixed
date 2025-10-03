import 'package:flutter/material.dart';
import '../../widgets/glass_container.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 420,
          child: GlassContainer(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Create account', style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 12),
                TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
                SizedBox(height: 8),
                TextField(controller: _password, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
                if (_error != null) ...[
                  SizedBox(height: 8),
                  Text(_error!, style: TextStyle(color: Colors.redAccent)),
                ],
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _busy ? null : () async {
                    setState(() { _busy = true; _error = null; });
                    final res = await auth.signUp(_email.text.trim(), _password.text.trim());
                    if (res != null && res['error'] != null) {
                      setState(() { _error = res['error'].toString(); });
                    } else {
                      Navigator.of(context).pop();
                    }
                    setState(() { _busy = false; });
                  },
                  child: _busy ? CircularProgressIndicator() : Text('Sign up'),
                  style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(48)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
