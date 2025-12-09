import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthSignUpRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              fullName: _nameController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is AuthSignUpSuccess) {
            // Manejar si requiere confirmación de email o login directo
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cuenta creada con éxito')),
            );
            if (!state.requiresEmailConfirmation) {
                 Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false,
                );
            } else {
                 Navigator.pop(context); // Volver al login
            }
          } else if (state is AuthAuthenticated) {
             Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AuthTextField(
                    controller: _nameController,
                    label: 'Nombre Completo',
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    validator: (val) => val != null && val.isNotEmpty ? null : 'Requerido',
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _emailController,
                    label: 'Email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _passwordController,
                    label: 'Contraseña',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: Validators.validatePassword,
                    onFieldSubmitted: (_) => _onRegisterPressed(),
                  ),
                  const SizedBox(height: 24),
                  AuthButton(
                    text: 'Registrarse',
                    onPressed: _onRegisterPressed,
                    isLoading: state is AuthLoading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}