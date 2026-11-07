import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../features/movie_details/widgets/auth widgets.dart';
import '../features/home/screens/main_screen.dart';
import 'Forget Password.dart';
import 'Register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Navigate to Main Screen
  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  // Login With Email And Password
  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      _goToHome();
    } on FirebaseAuthException catch (e) {
      debugPrint('Email Login Error: ${e.code} - ${e.message}');

      String message = 'Something went wrong';

      if (e.code == 'user-not-found') {
        message = 'No account found with this email';
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = 'Email or password is incorrect';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      debugPrint('Email Login Error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Something went wrong')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Login With Google
  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        serverClientId: '878241832038-smloe92on5i6i9u44h8sa2k24cctfkob.apps.googleusercontent.com',
      );

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;

      _goToHome();
    } on FirebaseAuthException catch (e) {
      debugPrint('Google Firebase Error: ${e.code} - ${e.message}');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Firebase Error: ${e.code}')),
      );
    } catch (e) {
      debugPrint('Google Login Error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Google Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              Image.asset('assets/images/images splach.png', height: 160),

              const SizedBox(height: 40),

              AppTextField(
                hint: 'Email',
                icon: Icons.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              AppTextField(
                hint: 'Password',
                icon: Icons.lock,
                isPassword: true,
                controller: _passwordController,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgetPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forget Password ?',
                    style: TextStyle(color: AppColors.yellow),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              AppButton(
                text: _isLoading ? 'Please Wait...' : 'Login',
                onPressed: _isLoading ? () {} : _login,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't Have Account ? ",
                    style: TextStyle(color: Colors.white),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Create One',
                      style: TextStyle(
                        color: AppColors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Row(
                children: [
                  Expanded(child: Divider(color: AppColors.yellow)),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR',
                      style: TextStyle(color: AppColors.yellow),
                    ),
                  ),

                  Expanded(child: Divider(color: AppColors.yellow)),
                ],
              ),

              const SizedBox(height: 20),

              AppButton(
                text: 'Login With Google',
                leading: const Icon(Icons.g_mobiledata, size: 34),
                onPressed: _isLoading ? () {} : _loginWithGoogle,
              ),

              const SizedBox(height: 24),

              const LanguageSwitch(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
