import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:talia/features/auth/presentation/cubit/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  double _fontProgress = 0.0;
  bool _fontsLoaded = false;
  bool _animationDone = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Start animation and font loading in parallel
    _controller.forward().then((_) {
      if (mounted) setState(() => _animationDone = true);
      _tryNavigate();
    });
    _loadFonts();
  }

  Future<void> _loadFonts() async {
    await QcfFontLoader.setupFontsAtStartup(
      onProgress: (progress) {
        if (mounted) setState(() => _fontProgress = progress);
      },
    );
    if (mounted) setState(() => _fontsLoaded = true);
    _tryNavigate();
  }

  void _tryNavigate() {
    // Only navigate when BOTH the logo animation AND font loading are done
    if (!_animationDone || !_fontsLoaded) return;
    final authState = context.read<AuthCubit>().state;
    _navigate(authState);
  }

  void _navigate(AuthState authState) {
    if (!mounted) return;
    if (authState is Authenticated) {
      context.go(RouteNames.homePath);
    } else if (authState is Unauthenticated || authState is AuthGuest) {
      context.go(RouteNames.onboardingPath);
    }
    // AuthLoading / AuthInitial → stay on splash, BlocListener will handle it
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (_animationDone && _fontsLoaded) {
          _navigate(state);
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primary],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // App logo + name
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Talia',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'القرآن الكريم',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Font loading progress indicator
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _fontsLoaded ? 1.0 : _fontProgress,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            minHeight: 3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _fontsLoaded
                              ? 'Ready'
                              : 'Loading Quran fonts...',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
