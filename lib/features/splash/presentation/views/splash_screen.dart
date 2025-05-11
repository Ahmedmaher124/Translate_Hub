import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grade3/core/utils/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // For the animated wave effect
  final List<Color> _waveColors = [
    Colors.blue.shade300.withOpacity(0.3),
    Colors.blue.shade400.withOpacity(0.4),
    Colors.blue.shade500.withOpacity(0.5),
  ];

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );

    // Scale animation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );

    // Rotation animation for the icon
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
    _rotationController.repeat();

    // Navigate to the next screen after animation completes
    Timer(const Duration(milliseconds: 3000), () {
      _rotationController.stop();

      // Fade out before navigation
      _fadeController.reverse().then((_) {
        if (mounted) {
          GoRouter.of(context).go(AppRouter.loginView);
        }
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated waves
            ..._buildWaves(),

            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo with rotation
                      Container(
                        width: size.width * 0.4,
                        height: size.width * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _rotationController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _rotationController.value * 2 * math.pi,
                                child: Icon(
                                  Icons.translate,
                                  size: size.width * 0.2,
                                  color: Colors.blue.shade700,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // App Name
                      Text(
                        'Translator',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.08,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tagline
                      Text(
                        'Breaking language barriers',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.0,
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Loading indicator
                      SizedBox(
                        width: size.width * 0.15,
                        height: size.width * 0.15,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Version info
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const Center(
                  child: Text(
                    'v1.0.0',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWaves() {
    final List<Widget> waves = [];

    for (int i = 0; i < _waveColors.length; i++) {
      final double delay = i * 0.2;

      waves.add(
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(
                  color: _waveColors[i],
                  amplitude: 30 + (i * 5),
                  frequency: 1.5 - (i * 0.1),
                  phase: (_rotationController.value * 2 * math.pi) + delay,
                ),
              );
            },
          ),
        ),
      );
    }

    return waves;
  }
}

class WavePainter extends CustomPainter {
  final Color color;
  final double amplitude;
  final double frequency;
  final double phase;

  WavePainter({
    required this.color,
    required this.amplitude,
    required this.frequency,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, size.height * 0.5);

    for (double x = 0; x < size.width; x++) {
      final y = size.height * 0.5 +
          amplitude *
              math.sin((x / size.width) * frequency * math.pi * 2 + phase);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}
