import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_service.dart';
import 'package:flutter_application_1/auth_service.dart'; // Import AuthService
import 'package:flutter_application_1/delivery_task_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ApiService apiService = ApiService();
  late Future<List<DeliveryTask>> _tasksFuture;

  @override
  void initState() {
    super.initState();
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
            onPressed: () async {
              // Panggil fungsi Logout dari AuthService
              await AuthService().signOut();
              // Tidak perlu Navigator.pop, AuthGate otomatis balik ke Login
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DeliveryTask>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final tasks = snapshot.data!;
            if (tasks.isEmpty) {
              return const Center(child: Text('Tidak ada data pengiriman.'));
            }
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
                    ),
                    subtitle: Text('ID Tugas: ${task.id}'),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Terjadi kesalahan.'));
        },
      ),
    );
  }
}
