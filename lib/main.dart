import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello flutters!'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5.0,
            children: [
              const Text('Login'),
              const TextField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
              const TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(onPressed: () {}, child: const Text('Login')),
              ElevatedButton(onPressed: () {}, child: const Text('Register')),
            ],
          ),
        ),
      ),
    );
  }
}
