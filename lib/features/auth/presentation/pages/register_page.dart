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

  // Mismos colores que en LoginPage para consistencia
  final Color _headerColor = const Color(0xFF0B1021);
  final Color _surfaceColor = const Color(0xFF151B2D);
  final Color _accentColor = const Color(0xFF3BC8E7);

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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _headerColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade400,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is AuthSignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cuenta creada con éxito'),
                behavior: SnackBarBehavior.floating,
              ),
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
            child: SizedBox(
              height: size.height,
              child: Column(
                children: [
                  // 1. SECCIÓN DE CABECERA
                  Expanded(
                    flex: 3, // Un poco más pequeño que el login para dar espacio a más campos
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SafeArea(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Botón de regresar
                            Positioned(
                              top: 16,
                              left: 0,
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Logo (Hero Animation)
                                Hero(
                                  tag: 'auth_logo',
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _accentColor.withOpacity(0.1),
                                      border: Border.all(color: _accentColor.withOpacity(0.3), width: 2),
                                    ),
                                    child: Icon(Icons.person_add_outlined, size: 32, color: _accentColor),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Crear Cuenta',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 2. SECCIÓN DEL FORMULARIO
                  Expanded(
                    flex: 7, // Más espacio para los 3 inputs
                    child: Container(
                      decoration: BoxDecoration(
                        color: _surfaceColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(32, 40, 32, 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Únete a nosotros',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30),
                              AuthTextField(
                                controller: _nameController,
                                label: 'Nombre Completo',
                                prefixIcon: Icons.person_outline,
                                textInputAction: TextInputAction.next,
                                validator: (val) => val != null && val.isNotEmpty ? null : 'Requerido',
                              ),
                              const SizedBox(height: 20),
                              AuthTextField(
                                controller: _emailController,
                                label: 'Correo Electrónico',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.validateEmail,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 20),
                              AuthTextField(
                                controller: _passwordController,
                                label: 'Contraseña',
                                prefixIcon: Icons.lock_outline,
                                isPassword: true,
                                validator: Validators.validatePassword,
                                onFieldSubmitted: (_) => _onRegisterPressed(),
                              ),
                              const SizedBox(height: 32),
                              AuthButton(
                                text: 'REGISTRARSE',
                                onPressed: _onRegisterPressed,
                                isLoading: state is AuthLoading,
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '¿Ya tienes cuenta?',
                                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Inicia Sesión',
                                      style: TextStyle(
                                        color: _accentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
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