import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(); // Instance Auth Service

  bool isPasswordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LogiTrack - Login'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_shipping,
                  size: 80, color: Colors.blueAccent),
              const SizedBox(height: 48),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Email tidak boleh kosong';
                  if (!value.contains('@')) return 'Format email salah';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => isPasswordVisible = !isPasswordVisible),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Password tidak boleh kosong';
                  if (value.length < 6) return 'Minimal 6 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // TOMBOL LOGIN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Panggil Service Login
                      final user = await _authService.signInWithEmailPassword(
                        emailController.text,
                        passwordController.text,
                      );

                      if (user == null) {
                        // Jika gagal
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Login Gagal! Cek email/password.')),
                          );
                        }
                      }
                      // Jika berhasil, AuthGate otomatis mengalihkan ke Dashboard
                    }
                  },
                  child: const Text('LOGIN', style: TextStyle(fontSize: 18)),
                ),
              ),

              const SizedBox(height: 16),

              // TOMBOL REGISTRASI (Tambahan agar bisa tes buat akun)
              TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final user = await _authService.registerWithEmailPassword(
                        emailController.text,
                        passwordController.text,
                      );
                      if (user != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Registrasi Berhasil! Silakan Login.')),
                        );
                      }
                    }
                  },
                  child: const Text(
                      'Belum punya akun? Daftar di sini (Isi form lalu klik ini)'))
            ],
          ),
        ),
      ),
    );
  }
}
