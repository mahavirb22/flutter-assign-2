import 'package:flutter/material.dart';
import 'Configurations.dart';
import 'utility.dart';

class RegisterPage extends StatefulWidget{
  @override
  _RegisterPageState createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage>{

  final _userIDController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String? _userIDErrorText;
  String? _passwordErrorText;
  bool _isPasswordObscure = true;
  bool _userIDExists = false;

  void _checkUserID() {
    String userId = _userIDController.text.trim();
    
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text("Please enter User ID first")),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    
    bool userExists = Utility.validateCredentials(userId: userId);
    
    if (userExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text("User ID already used")),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _userIDExists = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text("User ID available")),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _userIDExists = false;
      });
    }
  }

  void validate(){
    setState(() {
      _userIDErrorText = _setUserIDErrorText(_userIDController.text);
      _passwordErrorText = _setPasswordErrorText(_passwordController.text);
    });

    if (_userIDErrorText == null && _passwordErrorText == null && !_userIDExists) {
      Configurations.credentials.add({
        'userid': _userIDController.text.trim(),
        'password': _passwordController.text.trim()
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Center(child: Text("Registration Successful")),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text("Please fix the errors")),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String? _setUserIDErrorText(String value) {
    if (value.isEmpty) return 'Please enter User ID';
    if (!Utility.validateEmail(value)) return 'Please enter valid email ID';
    if (_userIDExists) return 'User ID already exists';
    return null;
  }

  String? _setPasswordErrorText(String value) {
    if (value.isEmpty) return 'Please enter Password';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('Register'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _userIDController,
                    onChanged: (value) {
                      setState(() {
                        _userIDErrorText = null;
                      });
                    },
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: _checkUserID,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Check', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      labelText: 'User ID',
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      errorText: _userIDErrorText,
                      hintText: 'example@email.com',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _isPasswordObscure,
                    onChanged: (value) {
                      setState(() {
                        _passwordErrorText = null;
                      });
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordObscure = !_isPasswordObscure;
                          });
                        },
                        icon: Icon(
                          _isPasswordObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      labelText: 'Password',
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      errorText: _passwordErrorText,
                      hintText: 'Min 8 characters',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: validate,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
