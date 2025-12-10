import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart'; // Asegúrate de tener tus colores aquí o defínelos localmente
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import 'forgot_password_page.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Definimos colores locales para asegurar el diseño profesional
  // Puedes moverlos a AppTheme si te gustan
  final Color _headerColor = const Color(0xFF0B1021); // Azul muy oscuro/Negro
  final Color _surfaceColor = const Color(0xFF151B2D); // Un poco más claro para el formulario
  final Color _accentColor = const Color(0xFF3BC8E7); // Tu color primario

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthSignInRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _headerColor, // El fondo base es el oscuro
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
          } else if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            // Usamos Column para dividir la pantalla
            child: SizedBox(
              height: size.height,
              child: Column(
                children: [
                  // 1. SECCIÓN DE CABECERA (Branding)
                  Expanded(
                    flex: 4, // Ocupa aprox 35-40% de la pantalla
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo con animación Hero
                          Hero(
                            tag: 'auth_logo',
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _accentColor.withOpacity(0.1),
                                border: Border.all(color: _accentColor.withOpacity(0.3), width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: _accentColor.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.lock_outline, size: 42, color: _accentColor),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Bienvenido',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Inicia sesión en tu cuenta corporativa',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. SECCIÓN DEL FORMULARIO (Bottom Sheet visual)
                  Expanded(
                    flex: 6, // Ocupa el resto de la pantalla
                    child: Container(
                      decoration: BoxDecoration(
                        color: _surfaceColor, // Color de superficie distinto
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
                                onFieldSubmitted: (_) => _onLoginPressed(),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white.withOpacity(0.6),
                                  ),
                                  child: const Text('¿Olvidaste tu contraseña?'),
                                ),
                              ),
                              const SizedBox(height: 24),
                              AuthButton(
                                text: 'INGRESAR',
                                onPressed: _onLoginPressed,
                                isLoading: state is AuthLoading,
                              ),
                              const Spacer(), // Empuja el contenido restante hacia abajo
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '¿Aún no tienes cuenta?',
                                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                                    ),
                                    child: Text(
                                      'Regístrate aquí',
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