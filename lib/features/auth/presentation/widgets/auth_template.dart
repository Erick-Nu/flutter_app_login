import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AuthTemplate extends StatelessWidget {
  final Widget child;

  const AuthTemplate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // GestureDetector para cerrar el teclado al tocar fuera
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.backgroundDark, AppTheme.backgroundLight],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: child, // Aquí va el contenido específico de cada página
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}