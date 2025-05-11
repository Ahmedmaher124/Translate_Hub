import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:grade3/core/utils/app_router.dart';
import 'package:grade3/features/auth/logic/login_cubit.dart';
import 'package:grade3/features/auth/logic/login_state.dart';
import 'package:grade3/features/auth/presentation/views/widgets/custom_textfield.dart';
import 'package:grade3/features/auth/presentation/views/signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _rotationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();

    // Repeat the rotation animation like in splash screen
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess || state is LoginAlreadyLoggedIn) {
              GoRouter.of(context).go(AppRouter.homeView);
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 100,
                    left: 20,
                    right: 20,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<LoginCubit>();

            return Stack(
              children: [
                // Background with waves
                _buildBackground(),

                // Main content
                SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height * 0.08),

                            // App Logo and Title
                            Center(
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _slideAnimation.value),
                                    child: Opacity(
                                      opacity: _fadeAnimation.value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: AnimatedBuilder(
                                          animation: _rotationController,
                                          builder: (context, child) {
                                            return Transform.rotate(
                                              angle: _rotationController.value *
                                                  2 *
                                                  math.pi,
                                              child: Icon(
                                                Icons.translate,
                                                size: 40,
                                                color: Colors.blue.shade700,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "TranslateHub",
                                      style: GoogleFonts.poppins(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            offset: const Offset(0, 2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Welcome Back",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.95),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Sign in to continue",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: size.height * 0.06),

                            // Login Form
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _slideAnimation.value),
                                  child: Opacity(
                                    opacity: _fadeAnimation.value,
                                    child: child,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 15,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Email Field
                                    CustomTextField(
                                      controller: _emailController,
                                      labelText: "Email",
                                      hintText: "Enter your email",
                                      isPassword: false,
                                    ),
                                    const SizedBox(height: 20),

                                    // Password Field with toggle visibility
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Password",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: _passwordController,
                                          obscureText: !_isPasswordVisible,
                                          decoration: InputDecoration(
                                            hintText: "Enter your password",
                                            hintStyle: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey.shade50,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _isPasswordVisible
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _isPasswordVisible =
                                                      !_isPasswordVisible;
                                                });
                                              },
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your password';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),

                                    // Forgot Password
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          // Handle forgot password
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.blue.shade700,
                                        ),
                                        child: Text(
                                          "Forgot Password?",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // Login Button
                                    state is LoginLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : SizedBox(
                                            width: double.infinity,
                                            height: 55,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  cubit.loginUser(
                                                    _emailController.text
                                                        .trim(),
                                                    _passwordController.text
                                                        .trim(),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blue.shade600,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                elevation: 2,
                                              ),
                                              child: Text(
                                                "Sign In",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Social Login and Sign Up
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _fadeAnimation.value,
                                  child: child,
                                );
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Divider(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              thickness: 1)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          "Or continue with",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Divider(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              thickness: 1)),
                                    ],
                                  ),

                                  const SizedBox(height: 20),

                                  // Social Login Buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildSocialButton(
                                        icon: Icons.g_mobiledata,
                                        color: Colors.red.shade400,
                                        onPressed: () {
                                          // Handle Google login
                                        },
                                      ),
                                      const SizedBox(width: 20),
                                      // _buildSocialButton(
                                      //   icon: Icons.facebook,
                                      //   color: Colors.blue.shade800,
                                      //   onPressed: () {
                                      //     // Handle Facebook login
                                      //   },
                                      // ),
                                      const SizedBox(width: 20),
                                      _buildSocialButton(
                                        icon: Icons.apple,
                                        color: Colors.black87,
                                        onPressed: () {
                                          // Handle Apple login
                                        },
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 30),

                                  // Sign Up Link
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account?",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          log("Navigation to SignUp triggered");
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUpView(),
                                            ),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                        ),
                                        child: Text(
                                          "Sign Up",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: size.height * 0.05),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade500,
          ],
        ),
      ),
      child: CustomPaint(
        painter: WavesPainter(),
        child: Container(),
      ),
    );
  }
}

class WavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // First wave
    final paint1 = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.75);

    for (double i = 0; i <= size.width; i++) {
      path1.lineTo(i,
          size.height * 0.75 + 20 * math.sin(i / 50) + 10 * math.cos(i / 30));
    }

    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint1);

    // Second wave
    final paint2 = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.8);

    for (double i = 0; i <= size.width; i++) {
      path2.lineTo(
          i, size.height * 0.8 + 15 * math.sin(i / 40) + 8 * math.cos(i / 25));
    }

    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);

    // Third wave
    final paint3 = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path3 = Path();
    path3.moveTo(0, size.height * 0.85);

    for (double i = 0; i <= size.width; i++) {
      path3.lineTo(
          i, size.height * 0.85 + 10 * math.sin(i / 30) + 5 * math.cos(i / 20));
    }

    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    path3.close();
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
