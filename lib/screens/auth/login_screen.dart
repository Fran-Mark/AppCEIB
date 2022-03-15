import 'dart:async';

import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/screens/auth/register_screen.dart';
import 'package:ceib/screens/auth/reset_password_screen.dart';
import 'package:ceib/widgets/policies.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
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
      if (_authProvider.errorMessage != "") {
        ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar(context: context, text: _authProvider.errorMessage),
        );
      }
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
    final _device = MediaQuery.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _form,
            child: SizedBox(
              width: _device.size.width > 800 ? 680 : _device.size.width * 0.85,
              child: Column(children: [
                Image.asset(
                  "lib/assets/logo_ceib.png",
                  height: 200,
                  width: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Bienvenido a la app del CEIB",
                  style: GoogleFonts.alfaSlabOne(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('Logueate para entrar',
                    style: GoogleFonts.patrickHandSc(fontSize: 20)),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_focusPassword);
                  },
                  validator: (email) {
                    if (email!.isEmpty) {
                      return "Ingresa el email";
                    } else {
                      _emailController.text = email;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  focusNode: _focusPassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _saveForm(),
                  validator: (password) {
                    if (password!.isEmpty) {
                      return "Ingresa una contraseña";
                    } else {
                      _passwordController.text = password;
                    }
                    return null;
                  },
                  controller: _passwordController,
                  obscureText: _isHidden,
                  decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: _toggleHidePassword,
                        child: _isHidden
                            ? const Icon(CupertinoIcons.eye_slash_fill)
                            : const Icon(CupertinoIcons.eye),
                      ),
                      hintText: "Contraseña",
                      prefixIcon: const Icon(Icons.password),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: MaterialButton(
                    onPressed: () => _saveForm(),
                    color: Theme.of(context).primaryColor,
                    height: 60,
                    minWidth: _loginProvider.isLoading ? null : double.infinity,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: _loginProvider.isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white))
                        : const Text(
                            "Ingresar",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                            RegisterScreen.routeName,
                            arguments: _emailController.text),
                        child: const Text('No tenés cuenta? Registrate')),
                    TextButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                            ResetPasswordScreen.routeName,
                            arguments: _emailController.text),
                        child: const Text('Me olvidé la contraseña')),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Policies()
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
