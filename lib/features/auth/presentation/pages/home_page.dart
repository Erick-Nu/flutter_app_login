import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el usuario actual del estado (si existe)
    final user = context.select((AuthBloc bloc) {
      if (bloc.state is AuthAuthenticated) {
        return (bloc.state as AuthAuthenticated).user;
      }
      return null;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthSignOutRequested());
            },
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¡Bienvenido!', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 10),
              if (user != null) ...[
                Text('Email: ${user.email}'),
                if (user.fullName != null) Text('Nombre: ${user.fullName}'),
              ]
            ],
          ),
        ),
      ),
    );
  }
}