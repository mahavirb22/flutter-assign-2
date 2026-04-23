import 'package:flutter/material.dart';
import 'Content.dart';
import 'register_page.dart';
import 'utility.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(     // Compulsary to use MaterialApp
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: 'Login: SAD LAB'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  final _userID = TextEditingController();
  final _password = TextEditingController();

  String? _userIDErrorText, _passwordErrorText;   // Can be nullable, as error text is optional

  final _userIDError = ValueNotifier<bool>(false);
  final _passwordError = ValueNotifier<bool>(false);
  final _isPasswordObscure = ValueNotifier<bool>(true);

  void validate(BuildContext context) {
    _userIDError.value = true;
    _passwordError.value = true;

    _userIDErrorText = _setUserIDErrorText(_userID.text);
    _passwordErrorText = _setPasswordErrorText(_password.text);

    if (_userIDErrorText == null && _passwordErrorText == null) {
      if (Utility.validateCredentials(
        userId: _userID.text.trim(),
        password: _password.text.trim(),
      )) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Content()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                "Invalid Credentials",
                style: TextStyle(fontSize: 20),
              ),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                "Try Sign Up",
                style: TextStyle(fontSize: 20),
              ),
            ),
            backgroundColor: Colors.deepOrange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String? _setUserIDErrorText(String value) {
    if (value.isEmpty) return 'Please enter email ID';
    if (!Utility.validateEmail(value)) return 'Please enter valid email ID';
    return null;
  }

  String? _setPasswordErrorText(String value) {
    if (value.isEmpty) return 'Please enter Password';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ValueListenableBuilder<bool>(
                valueListenable: _userIDError,
                builder: (context, value, child) {
                  return ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _userID,
                    builder: (context, value, child) {
                      _userIDErrorText = _userIDError.value
                          ? _setUserIDErrorText(value.text)
                          : null;

                      return TextField(
                        controller: _userID,
                        onChanged: !_userIDError.value ? (value) {
                          _userIDError.value = true;
                        } : null,
                        decoration: InputDecoration(
                          labelText: 'User ID',
                          labelStyle:
                          const TextStyle(fontWeight: FontWeight.bold),
                          errorText: _userIDErrorText,
                          hintText: 'dhiraj.jadhav@vit.edu',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ValueListenableBuilder<bool>(
                valueListenable: _passwordError,
                builder: (context, value, child) {
                  return ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _password,
                    builder: (context, value, child) {
                      _passwordErrorText = _passwordError.value
                          ? _setPasswordErrorText(value.text)
                          : null;

                      return ValueListenableBuilder<bool>(
                        valueListenable: _isPasswordObscure,
                        builder: (context, value, child) {
                          return TextField(
                            obscureText: _isPasswordObscure.value,
                            controller: _password,
                            onChanged: !_passwordError.value
                                ? (value) {
                              _passwordError.value = true;
                            }
                                : null,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _isPasswordObscure.value =
                                  !_isPasswordObscure.value;
                                },
                                icon: Icon(
                                  _isPasswordObscure.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              label: const Text(
                                'Password',
                                style:
                                TextStyle(fontWeight: FontWeight.bold),
                              ),
                              errorText: _passwordErrorText,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                validate(context);
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}