import 'package:error_manager/setup_error_manager.dart';
import 'package:flutter/material.dart';

void main() {
  // Initialize the error manager
  setupErrorManager();
  runApp(MyApp());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error Manager Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button to trigger an error
            ElevatedButton(
              onPressed: () {
                // Simulate an error
                throw Exception('This is a test exception!');
              },
              child: const Text('Trigger Error'),
            ),
            const SizedBox(height: 20),
            // Button to trigger a widget error
            ElevatedButton(
              onPressed: () {
                // Invalid widget to trigger Flutter's error screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => InvalidWidget()),
                );
              },
              child: const Text('Trigger Widget Error'),
            ),
          ],
        ),
      ),
    );
  }
}

class InvalidWidget extends StatelessWidget {
  late String undefinedVariable;
  InvalidWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // This widget will throw an error
    return Container(
      child: Text(undefinedVariable), // Undefined variable on purpose
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Error Manager Demo',
      home: HomeScreen(),
    );
  }
}
