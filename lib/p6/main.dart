import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Profile'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _nameTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();
  File? _image;
  final _picker = ImagePicker();

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _nameTextEditingController.text = prefs.getString('name') ?? '';
    _emailTextEditingController.text = prefs.getString('email') ?? '';
  }

  Future<void> _updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _nameTextEditingController.text);
    prefs.setString('email', _emailTextEditingController.text);
  }

  @override
  void initState() {
    _loadProfile();
    loadProfileImage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameTextEditingController.dispose();
    _emailTextEditingController.dispose();
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> savePicture() async {
    if (_image != null) {
      try {
        final appDocDir = await getApplicationDocumentsDirectory();
        final newImagePath = '${appDocDir.path}/profile_image.jpg';
        await _image!.copy(newImagePath);
        print('Picture saved to $newImagePath');
      } catch (e) {
        print('Error saving picture: $e');
      }
    } else {
      AlertDialog(
        title: const Text('Profile Picture'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Profile Image.'),
              Text('Profile Image file is missing.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }

  Future<void> loadProfileImage() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final imagePath = '${appDocDir.path}/profile_image.jpg';

    final file = File(imagePath);

    if (await file.exists()) {
      setState(() {
        _image = file;
        print('Picture loaded from $imagePath');
      });
    } else {
      print('Picture not found at $imagePath');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            spacing: 8.0,
            children: [
              _image == null
                  ? Image.asset(
                      'assets/images/profile.png',
                      width: 100,
                      height: 100,
                    )
                  : Image.file(_image!, width: 100, height: 100),
              const SizedBox(height: 8.0),
              IconButton(
                onPressed: () {
                  getImageFromGallery();
                },
                icon: Icon(Icons.edit),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: _nameTextEditingController,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                controller: _emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
              ),
              const Expanded(child: SizedBox()),
              ElevatedButton(
                onPressed: () async {
                  await _updateProfile();
                  await savePicture();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile info saved')),
                  );
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
