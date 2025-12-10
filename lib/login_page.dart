import 'package:flutter/material.dart';
import 'package:flutter_application_1/dashboard_page.dart';
import 'package:flutter_application_1/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variabel state untuk mengontrol visibilitas password
  bool isPasswordVisible = false;

  //Controller untuk mengambil input
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_shipping,
              size: 80,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 48),

            // Input Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Input Password dengan Visibility Toggle
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible, // tidak hardcoded
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                // ==========================================================
                onPressed: () async {
                  // Membuat instance dari ApiService
                  final apiService = ApiService();

                  try {
                    // Panggil method dan tunggu hasilnya
                    final tasks = await apiService.fetchDeliveryTasks();

                    // Cetak jumlah data dan judul data pertama ke console
                    print('Berhasil mengambil data: ${tasks.length} item.');
                    if (tasks.isNotEmpty) {
                      print('Judul data pertama: ${tasks.first.title}');
                    }
                  } catch (e) {
                    print(e);
                  }

                  // Navigasi tetap dilakukan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage(),
                    ),
                  );
                },

                // ==========================================================
                child: const Text('LOGIN', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
