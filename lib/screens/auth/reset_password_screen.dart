import 'package:ceib/providers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/helper_functions.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);
  static const routeName = '/reset-password';

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    final email = _emailController.text;
    final result = await Provider.of<AuthServices>(context, listen: false)
        .resetPassword(email);
    if (result == null) {
      final _authProvider = Provider.of<AuthServices>(context, listen: false);
      final snackBar = buildSnackBar(
        context: context,
        text: _authProvider.errorMessage,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Navigator.of(context).pop();
      final snackBar =
          buildSnackBar(context: context, text: 'Se envió el correo');

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void didChangeDependencies() {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as String?;
    if (routeArgs != null && routeArgs != '') _emailController.text = routeArgs;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthServices>(context);
    final _device = MediaQuery.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                    "Me olvidé la contraseña",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Genera una nueva contraseña',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autofocus: true,
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    validator: (email) =>
                        email!.isEmpty ? "Ingresa el email" : null,
                    decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onFieldSubmitted: (_) => _saveForm(),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: MaterialButton(
                      onPressed: () => _saveForm(),
                      color: Theme.of(context).primaryColor,
                      height: 60,
                      minWidth: authProvider.isLoading ? null : double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: authProvider.isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              "Cambiar contraseña",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
