import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:int/edit_item.dart';
import 'package:flutter/material.dart';
import 'package:int/globals.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:path/path.dart' as path;


class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
    String selectedImagePath = '';
  Future<Image> fetchImage() async {
  var url = 'http://$server:8000/users/my_profile_picture/'; // replace with your image URL
  var headers = {
    'Authorization': 'Token $token', // replace with your token
  };
  var response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 200) {
    return Image.memory(base64Decode(base64Encode(response.bodyBytes)), height: 100, width: 100,);
  } else {
    throw Exception('Failed to load image');
  }
}

Upload(File imageFile) async {    
    var stream = new http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var uri = Uri.parse('http://$server:8000/users/my_profile_picture/');

     var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('picture', stream, length,
          filename: path.basename(imageFile.path));
          //contentType: new MediaType('image', 'png'));
        request.headers['Authorization'] = 'Token $token';
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }

     Future<String?> update_profile(String email, String name, String gender, String age) async {
  var url = Uri.parse('http://${server}:8000/users/my_profile/');
  final response = await put(url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'email': email,
        'gneder': gender,
        'name': name,
        'age': age,
      }));
  Map data = json.decode(response.body);
  return data['email'];
}
  String gender = myProfile!.gender!;
   final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = '${myProfile!.firstName!} ${myProfile!.lastName!}';
    _ageController.text = myProfile!.age.toString();
    _emailController.text = myProfile!.email!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async{
                if (_formKey.currentState!.validate()) {
                  await update_profile(
                    _emailController.text,
                    _nameController.text,
                    gender,
                    _ageController.text);
                }
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                fixedSize: Size(60, 50),
                elevation: 3,
              ),
              icon: Icon(Ionicons.checkmark, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Account",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Photo",
                widget: Column(
                  children: [
                    FutureBuilder<Image>(
  future: fetchImage(),
  builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return snapshot.data!;
    }
  },
),
                    TextButton(
                      onPressed: () async {
              await selectImage();
              if (selectedImagePath != '') {
                File imageFile = File(selectedImagePath);
                await Upload(imageFile);
              }
              setState(() {});
            },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue.shade300,
                      ),
                      child: const Text("Upload Image"),
                    )
                  ],
                ),
              ),
               EditItem(
                title: "Name",
                widget: TextField(controller: _nameController,),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Gender",
                widget: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          gender = "male";
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: gender == "male"
                            ? Colors.blue.shade300
                            : Colors.grey.shade200,
                        fixedSize: const Size(50, 50),
                      ),
                      icon: Icon(
                        Ionicons.male,
                        color: gender == "male" ? Colors.white : Colors.black,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          gender = "female";
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: gender == "female"
                            ? Colors.blue.shade300
                            : Colors.grey.shade200,
                        fixedSize: const Size(50, 50),
                      ),
                      icon: Icon(
                        Ionicons.female,
                        color: gender == "female" ? Colors.white : Colors.black,
                        size: 18,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
               EditItem(
                widget: TextField(controller: _ageController,),
                title: "Age",
              ),
              const SizedBox(height: 40),
               EditItem(
                widget: TextField(controller: _emailController,),
                title: "Email",
              ),
            ],
          ),
        ),
      ),
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
