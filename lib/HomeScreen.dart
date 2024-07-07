import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:int/AccountScreen.dart';


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'globals.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedImagePath = '';
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeContent(),
    const AccountScreen(),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
        backgroundColor:  Colors.blue[300],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.blue.shade300,
        animationDuration: Duration(milliseconds: 300),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          Icon(
            Icons.camera_alt,
            color: Colors.purple.shade50,
          ),
          Icon(
            Icons.settings,
            color: Colors.purple.shade50,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _children[_currentIndex],
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String selectedImagePath = '';
  String text = '';

  MapEntry<String, int>? getMaxEntry(Map<String, int> dict) {
  MapEntry<String, int>? maxEntry;
  dict.forEach((key, value) {
    if (maxEntry == null || value > maxEntry!.value) {
      maxEntry = MapEntry(key, value);
    }
  });
  return maxEntry;
}

    Future<List?> Upload(File imageFile) async {    
    var stream = new http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var uri = Uri.parse('http://$server:8000/diagnosis/diagnosis_picture/');

     var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('picture', stream, length,
          filename: path.basename(imageFile.path));
          //contentType: new MediaType('image', 'png'));
        request.headers['Authorization'] = 'Token $token';
      request.files.add(multipartFile);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      List<dynamic> map = json.decode(responseBody);
      return map;
    }

  @override
  Widget build(BuildContext context) {
  return Stack(
    children: [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedImagePath == ''
                ? Image.asset(
                    'assets/images/image_placeholder.png',
                    height: 200,
                    width: 200,
                    fit: BoxFit.fill,
                  )
                : Image.file(
                    File(selectedImagePath),
                    height: 200,
                    width: 200,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 30),
            selectedImagePath == '' 
                ? Text(
                    'Start scan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                  )
                : SizedBox(height: 0), 
            SizedBox(
              height: 10.0,
            ),
            Text(text),
            const SizedBox(height: 10),
          ],
        ),
      ),
      Positioned(
        bottom: 20,
        right: 20,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade300,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.all(20),
          child: InkWell(
            onTap: () async {
              await selectImage();
              if (selectedImagePath != '') {
                File imageFile = File(selectedImagePath);
                List? map = await Upload(imageFile);
                if (map != null){
                  setState(() {
                    text = 'Prediction: ${map[0][0]}\nConfidence: ${(map[0][1] * 100).toStringAsFixed(2)}%';
                  });
                }
              }
              setState(() {});
            },
            child: Icon(Icons.add, color: Colors.purple.shade50),
          ),
        ),
      ),
    ],
  );
}

  Future selectImage() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 170,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    'Select Image From :',
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          selectedImagePath = await selectImageFromGallery();
                          print('Image_Path:-');
                          print(selectedImagePath);
                          if (selectedImagePath != '') {
                            Navigator.pop(context);
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("No Image Selected !"),
                              ),
                            );
                          }
                        },
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/gallery.png',
                                  height: 60,
                                  width: 60,
                                ),
                                Text('Gallery'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          selectedImagePath = await selectImageFromCamera();
                          print('Image_Path:-');
                          print(selectedImagePath);

                          if (selectedImagePath != '') {
                            Navigator.pop(context);
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("No Image Captured !"),
                              ),
                            );
                          }
                        },
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/camera.png',
                                  height: 60,
                                  width: 60,
                                ),
                                Text('Camera'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }
}
