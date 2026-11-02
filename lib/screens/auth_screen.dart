import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({required this.register, super.key});
  final bool register;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final key = GlobalKey<FormState>(),
      email = TextEditingController(),
      password = TextEditingController(),
      confirm = TextEditingController();
  bool submitted = false, busy = false;
  String? firebaseError;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  String? emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()))
      return 'Please enter a valid email address';
    return null;
  }

  String? passwordValidator(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (widget.register && v.length < 6)
      return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> submit() async {
    setState(() => submitted = true);
    if (!(key.currentState?.validate() ?? false)) return;
    setState(() {
      busy = true;
      firebaseError = null;
    });
    try {
      if (widget.register) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text,
        );
        if (mounted) showSuccess(context, 'Registration successful');
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text,
        );
      }
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    } on FirebaseAuthException catch (e) {
      setState(() => firebaseError = e.message ?? 'Authentication failed');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRegister = widget.register;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('BookShelf'),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: key,
            autovalidateMode: submitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRegister ? 'Create your account' : 'Welcome back',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  isRegister
                      ? 'Start building your personal reading library.'
                      : 'Sign in to continue to your private library.',
                  style: const TextStyle(
                    color: AppColors.neutral600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                AppCard(
                  child: Column(
                    children: [
                      LabeledField(
                        label: 'Email',
                        child: TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          validator: emailValidator,
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      LabeledField(
                        label: 'Password',
                        child: PasswordField(
                          controller: password,
                          hint: 'Enter your password',
                          validator: passwordValidator,
                        ),
                      ),
                      if (isRegister) ...[
                        const SizedBox(height: 16),
                        LabeledField(
                          label: 'Confirm password',
                          child: PasswordField(
                            controller: confirm,
                            hint: 'Confirm your password',
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return 'Confirm password is required';
                              if (v != password.text)
                                return 'Passwords do not match';
                              return null;
                            },
                          ),
                        ),
                      ],
                      if (firebaseError != null) ...[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            firebaseError!,
                            style: const TextStyle(color: AppColors.error700),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: busy ? null : submit,
                          child: Text(isRegister ? 'Register' : 'Login'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AuthScreen(register: !isRegister),
                      ),
                    ),
                    child: Text(
                      isRegister
                          ? 'Already have an account? Login'
                          : 'New to BookShelf? Register',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
