import 'package:flutter/material.dart';
import 'package:flutter_application_1/dashboard_page.dart';
import 'package:flutter_application_1/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. Tambahkan GlobalKey untuk FormState
  final _formKey = GlobalKey<FormState>();

  // Variabel state untuk mengontrol visibilitas password
  bool isPasswordVisible = false;

  // Controller untuk mengambil input
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
        // 2. Bungkus Column dengan Form dan berikan key
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_shipping,
                size: 80,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 48),

              // 3. Ganti TextField menjadi TextFormField untuk Email
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                // 4. Tambahkan validator email
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Masukkan format email yang valid';
                  }
                  return null; // Return null jika valid
                },
              ),

              const SizedBox(height: 16),

              // 3. Ganti TextField menjadi TextFormField untuk Password
              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
                // 4. Tambahkan validator password
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal harus 6 karakter';
                  }
                  return null; // Return null jika valid
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // 5. Cek apakah form valid sebelum melanjutkan
                    if (_formKey.currentState!.validate()) {
                      // Jika valid, jalankan logika login/API
                      print('Form valid!');

                      // Membuat instance dari ApiService
                      final apiService = ApiService();

                      try {
                        // Panggil method dan tunggu hasilnya
                        final tasks = await apiService.fetchDeliveryTasks();

                        print('Berhasil mengambil data: ${tasks.length} item.');
                        if (tasks.isNotEmpty) {
                          print('Judul data pertama: ${tasks.first.title}');
                        }
                      } catch (e) {
                        print(e);
                      }

                      // Navigasi ke halaman dashboard
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardPage(),
                          ),
                        );
                      }
                    } else {
                      print('Form tidak valid!');
                    }
                  },
                  child: const Text('LOGIN', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
