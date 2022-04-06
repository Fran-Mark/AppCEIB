import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/services/sheets/sheets_api.dart';
import 'package:ceib/widgets/policies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
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
    final _esSocio = await SheetsAPI.esSocio(_emailController.text);
    if (_esSocio) {
      final _user = await Provider.of<AuthServices>(context, listen: false)
          .register(_emailController.text.trim(), _passwordController.text);

      if (_user == null) {
        final _authProvider = Provider.of<AuthServices>(context, listen: false);
        if (_authProvider.errorMessage != "") {
          ScaffoldMessenger.of(context).showSnackBar(
            buildSnackBar(context: context, text: _authProvider.errorMessage),
          );
        }
      } else {
        Navigator.of(context).pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
          context: context, text: "No estás en nuestra base de datos :("));
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
    final _device = MediaQuery.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _form,
            child: SizedBox(
              width: _device.size.width > 800 ? 680 : _device.size.width * 0.85,
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
                  const SizedBox(
                    height: 60,
                  ),
                  const Text(
                    "Registrarse",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Crear una cuenta',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      val ??= "";
                      final email = val.trim();
                      if (email.isEmpty) {
                        return "Ingresa el email";
                      } else if (email.endsWith('@ib.edu.ar')) {
                        _emailController.text = email;
                        return null;
                      } else {
                        _emailController.text = email;
                      }
                      return "Usá tu mail del IB";
                    },
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_focusPassword);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    focusNode: _focusPassword,
                    textInputAction: TextInputAction.next,
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
                      hintText: "Contraseña",
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: InkWell(
                        onTap: _toggleHidePassword,
                        child: _isHidden
                            ? const Icon(CupertinoIcons.eye_slash_fill)
                            : const Icon(CupertinoIcons.eye),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_focusConfirmPassword);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    focusNode: _focusConfirmPassword,
                    textInputAction: TextInputAction.done,
                    validator: (password) {
                      if (password != _passwordController.text) {
                        return "Las contraseñas no coinciden";
                      } else {
                        _passwordController.text = password!;
                      }
                      return null;
                    },
                    controller: _confirmPasswordController,
                    obscureText: _isConfirmHidden,
                    decoration: InputDecoration(
                      hintText: "Confirmar contraseña",
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: InkWell(
                        onTap: _toggleHideConfirmPassword,
                        child: _isConfirmHidden
                            ? const Icon(CupertinoIcons.eye_slash_fill)
                            : const Icon(CupertinoIcons.eye),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                  ),
                  const SizedBox(
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: registerProvider.isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              "Registrarse",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Policies()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
