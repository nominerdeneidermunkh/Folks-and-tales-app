import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:folks/utils/folks_color.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _imageUrl = '';
  String phoneNo = '';

  bool _isEditing = false;

  File? _image;

  Future<void> _uploadImage() async {
    if (_image == null) {
      return;
    }

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName.jpg');
      UploadTask uploadTask = storageReference.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;

      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      _auth.currentUser?.updatePhotoURL(downloadURL);

      setState(() {
        _imageUrl = downloadURL;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image uploaded successfully'),
        ),
      );
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      _uploadImage();
    }
  }

  @override
  void initState() {
    super.initState();

    User? user = _auth.currentUser;
    _imageUrl = user?.photoURL ?? '';

    fetchUserData();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _updateUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({
          'Name': _nameController.text,
          'Email': user.email,
          'Phone': _phoneController.text,
        });
        user.updateDisplayName(_nameController.text);

        if (_passwordController.text.isNotEmpty) {
          await user.updatePassword(_passwordController.text);
        }
      } catch (e) {
        print('Error updating user data: $e');
      }
    }
  }

  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    final data = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.uid)
        .get();
    _phoneController.text = data['Phone'] ?? '';
    _nameController.text = data['Name'] ?? '';
    _emailController.text = user!.email ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.done : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _updateUserData();
              }
              _toggleEditing();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: FolksColor.secondary,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(1),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: _imageUrl,
                      fit: BoxFit.cover,
                      height: 128,
                      width: 128,
                      errorWidget: (context, val, ob) {
                        return Container(
                          height: 128,
                          width: 128,
                          color: FolksColor.secondary,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 50,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Зураг \nоруулах',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildFieldWithIcon(Icons.person, 'Name', _nameController),
              const SizedBox(height: 12),
              _buildFieldWithIcon(Icons.email, 'Email', _emailController),
              SizedBox(height: 12),
              _buildFieldWithIcon(Icons.phone, phoneNo, _phoneController),
              SizedBox(height: 16),
              if (_isEditing)
                _buildFieldWithIcon(
                    Icons.lock, 'Password', _passwordController),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff4D83D3),
                  onPrimary: Color(0xff091227),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldWithIcon(
      IconData icon, String label, TextEditingController controller) {
    log('message: $label');
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xff091227),
        contentPadding: EdgeInsets.all(12),
        labelStyle: TextStyle(color: Colors.white),
      ),
      enabled: _isEditing,
      obscureText: label == 'Password',
      style: TextStyle(color: Colors.white),
    );
  }
}
