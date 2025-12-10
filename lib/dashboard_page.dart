import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_service.dart';
import 'package:flutter_application_1/delivery_task_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // 1. Buat instance ApiService
  final ApiService apiService = ApiService();

  // 2. Buat variabel untuk menampung hasil dari future
  late Future<List<DeliveryTask>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    // 3. Panggil API dan simpan future-nya ke variabel saat inisialisasi
    _tasksFuture = apiService.fetchDeliveryTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Pengiriman'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Kembali ke halaman Login
              Navigator.pop(context);
            },
          ),
        ],
      ),
      // 4. Gunakan FutureBuilder untuk menangani data asinkron
      body: FutureBuilder<List<DeliveryTask>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          // Kondisi 1: Saat data sedang dimuat
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Kondisi 2: Jika terjadi error
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Kondisi 3: Jika data berhasil dimuat
          else if (snapshot.hasData) {
            final tasks = snapshot.data!;

            // Cek jika data kosong
            if (tasks.isEmpty) {
              return const Center(child: Text('Tidak ada data pengiriman.'));
            }

            // Gunakan ListView.builder untuk performa lebih baik
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.isCompleted ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text('ID Tugas: ${task.id}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Aksi ketika item diklik (bisa ditambahkan navigasi detail nanti)
                    },
                  ),
                );
              },
            );
          }
          // Kondisi default
          return const Center(
            child: Text('Terjadi kesalahan tidak diketahui.'),
          );
        },
      ),
    );
  }
}
