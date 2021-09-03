import 'dart:async';

import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/screens/register_screen.dart';
import 'package:ceib/screens/reset_password_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _focusPassword = FocusNode();

  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    final user = await Provider.of<AuthServices>(context, listen: false)
        .login(_emailController.text.trim(), _passwordController.text);

    if (user == null) {
      final _authProvider = Provider.of<AuthServices>(context, listen: false);
      if (_authProvider.errorMessage != "")
        ScaffoldMessenger.of(context).showSnackBar(
            buildSnackbar(context: context, text: _authProvider.errorMessage));
    }
  }

  var _isHidden = true;
  void _toggleHidePassword() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _loginProvider = Provider.of<AuthServices>(context);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: SizedBox(
                width: 600,
                child: Column(children: [
                  Image.asset(
                    "lib/assets/logo_ceib.jpg",
                    height: 200,
                    width: 200,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Bienvenido a la app del CEIB",
                    style: GoogleFonts.alfaSlabOne(fontSize: 22),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Logueate para entrar',
                      style: GoogleFonts.patrickHandSc(fontSize: 20)),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_focusPassword);
                    },
                    validator: (email) {
                      if (email!.isEmpty)
                        return "Ingresa el email";
                      else
                        _emailController.text = email;
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    focusNode: _focusPassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _saveForm(),
                    validator: (password) {
                      if (password!.isEmpty)
                        return "Ingresa una contraseña";
                      else
                        _passwordController.text = password;
                      return null;
                    },
                    controller: _passwordController,
                    obscureText: _isHidden,
                    decoration: InputDecoration(
                        suffixIcon: InkWell(
                          child: _isHidden
                              ? Icon(CupertinoIcons.eye_slash_fill)
                              : Icon(CupertinoIcons.eye),
                          onTap: _toggleHidePassword,
                        ),
                        hintText: "Contraseña",
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: MaterialButton(
                      onPressed: () => _saveForm(),
                      color: Theme.of(context).primaryColor,
                      height: 60,
                      minWidth:
                          _loginProvider.isLoading ? null : double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: _loginProvider.isLoading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white))
                          : Text(
                              "Ingresar",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pushNamed(
                              RegisterScreen.routeName,
                              arguments: _emailController.text),
                          child: Text('No tenés cuenta? Registrate')),
                      TextButton(
                          onPressed: () => Navigator.of(context).pushNamed(
                              ResetPasswordScreen.routeName,
                              arguments: _emailController.text),
                          child: Text('Me olvidé la contraseña')),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
