import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);
  static const routeName = '/register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _focusPassword = FocusNode();
  final _focusConfirmPassword = FocusNode();

  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _focusPassword.dispose();
    _focusConfirmPassword.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    final _user = await Provider.of<AuthServices>(context, listen: false)
        .register(_emailController.text.trim(), _passwordController.text);

    if (_user == null) {
      final _authProvider = Provider.of<AuthServices>(context, listen: false);
      if (_authProvider.errorMessage != "")
        ScaffoldMessenger.of(context).showSnackBar(
            buildSnackBar(context: context, text: _authProvider.errorMessage));
    } else {
      Navigator.of(context).pop();
    }
  }

  var _isHidden = true;
  void _toggleHidePassword() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  var _isConfirmHidden = true;
  void _toggleHideConfirmPassword() {
    setState(() {
      _isConfirmHidden = !_isConfirmHidden;
    });
  }

  @override
  void didChangeDependencies() {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as String?;
    if (routeArgs != null && routeArgs != '') _emailController.text = routeArgs;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<AuthServices>(context);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: FractionallySizedBox(
                widthFactor: .85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Theme.of(context).primaryColor,
                        )),
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      "Registrarse",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Crear una cuenta',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      //autofocus: true,
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      validator: (email) {
                        if (email!.isEmpty)
                          return "Ingresa el email";
                        else if (email.endsWith('@ib.edu.ar')) {
                          _emailController.text = email;
                          return null;
                        } else
                          _emailController.text = email;
                        return "Usá tu mail del IB";
                      },
                      decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_focusPassword);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      focusNode: _focusPassword,
                      textInputAction: TextInputAction.next,
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
                          hintText: "Contraseña",
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: InkWell(
                            child: _isHidden
                                ? Icon(CupertinoIcons.eye_slash_fill)
                                : Icon(CupertinoIcons.eye),
                            onTap: _toggleHidePassword,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_focusConfirmPassword);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      focusNode: _focusConfirmPassword,
                      textInputAction: TextInputAction.done,
                      validator: (password) {
                        if (password != _passwordController.text)
                          return "Las contraseñas no coinciden";
                        else
                          _passwordController.text = password!;
                        return null;
                      },
                      controller: _confirmPasswordController,
                      obscureText: _isConfirmHidden,
                      decoration: InputDecoration(
                          hintText: "Confirmar contraseña",
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: InkWell(
                            child: _isConfirmHidden
                                ? Icon(CupertinoIcons.eye_slash_fill)
                                : Icon(CupertinoIcons.eye),
                            onTap: _toggleHideConfirmPassword,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
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
                            registerProvider.isLoading ? null : double.infinity,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: registerProvider.isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                "Registrarse",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
