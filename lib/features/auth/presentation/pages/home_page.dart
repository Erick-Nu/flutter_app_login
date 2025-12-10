import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos la paleta de colores aquí para fácil acceso
    const Color headerColor = Color(0xFF0B1021);
    const Color surfaceColor = Color(0xFF151B2D);
    const Color accentColor = Color(0xFF3BC8E7);

    final user = context.select((AuthBloc bloc) {
      if (bloc.state is AuthAuthenticated) {
        return (bloc.state as AuthAuthenticated).user;
      }
      return null;
    });

    return Scaffold(
      backgroundColor: headerColor,
      // Usamos un Stack para elementos decorativos de fondo
      body: Stack(
        children: [
          // Decoración: Glow superior derecho
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.2),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          // Contenido Principal
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // 1. Cabecera Personalizada
                  _buildHeader(context, user),
                  
                  const SizedBox(height: 20),

                  // 2. Panel Inferior (Dashboard)
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 100), // Padding extra abajo para el nav bar
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tarjeta de Estado Principal
                              _buildStatusCard(user, accentColor),
                              
                              const SizedBox(height: 32),
                              
                              // Sección de Acciones Rápidas
                              const Text(
                                'Acciones Rápidas',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildQuickActionsGrid(accentColor),

                              const SizedBox(height: 32),

                              // Sección de Actividad Reciente
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Actividad Reciente',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {}, 
                                    child: Text(
                                      'Ver todo',
                                      style: TextStyle(color: accentColor.withOpacity(0.8)),
                                    )
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildRecentActivityList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Barra de Navegación "Flotante"
      extendBody: true,
      bottomNavigationBar: _buildBottomNavBar(surfaceColor, accentColor),
    );
  }

  Widget _buildHeader(BuildContext context, UserEntity? user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenido de nuevo,',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.fullName?.split(' ')[0] ?? 'Usuario', // Solo el primer nombre
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Avatar con borde
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFF1F2940),
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(UserEntity? user, Color accentColor) {
    final bool isVerified = user?.emailConfirmed ?? false;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isVerified 
              ? [const Color(0xFF2E7D32).withOpacity(0.8), const Color(0xFF1B5E20).withOpacity(0.8)]
              : [const Color(0xFFE65100).withOpacity(0.8), const Color(0xFFBF360C).withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isVerified ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isVerified ? Icons.verified_user : Icons.gpp_maybe,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                isVerified ? 'Cuenta Segura' : 'Acción Requerida',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isVerified 
              ? 'Tu identidad ha sido verificada correctamente. Tienes acceso total al sistema.'
              : 'Por favor verifica tu correo electrónico para desbloquear todas las funciones.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user?.email ?? 'email@ejemplo.com',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(Color accentColor) {
    final actions = [
      {'icon': Icons.security, 'label': 'Seguridad'},
      {'icon': Icons.description_outlined, 'label': 'Datos'},
      {'icon': Icons.notifications_none, 'label': 'Alertas'},
      {'icon': Icons.help_outline, 'label': 'Ayuda'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((action) => _buildActionButton(
        icon: action['icon'] as IconData,
        label: action['label'] as String,
        color: accentColor,
      )).toList(),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color}) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {}, // Acción simulada
              child: Icon(icon, color: color, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildRecentActivityList() {
    // Datos simulados para diseño
    final activities = [
      {'title': 'Inicio de sesión exitoso', 'time': 'Hoy, 10:23 AM', 'icon': Icons.login},
      {'title': 'Cambio de contraseña', 'time': 'Ayer, 04:15 PM', 'icon': Icons.lock_clock},
      {'title': 'Actualización de perfil', 'time': '20 Oct, 09:00 AM', 'icon': Icons.edit},
    ];

    return Column(
      children: activities.map((activity) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.03)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B1021),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(activity['icon'] as IconData, color: Colors.white70, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity['time'] as String,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3), size: 18),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNavBar(Color surfaceColor, Color accentColor) {
    return Container(
      margin: const EdgeInsets.all(24),
      height: 70,
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.9), // Glassy effect
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_filled, true, accentColor),
            _buildNavItem(Icons.pie_chart_outline, false, Colors.white54),
            _buildNavItem(Icons.settings_outlined, false, Colors.white54),
            // Botón de Logout integrado en el NavBar
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthSignOutRequested());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: isActive ? BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ) : null,
      child: Icon(icon, color: color, size: 26),
    );
  }
}