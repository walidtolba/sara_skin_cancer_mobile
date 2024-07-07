import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:int/edit_screen.dart';
import 'package:int/setting_item.dart';
import 'package:ionicons/ionicons.dart';
import 'package:int/globals.dart';
import 'package:http/http.dart' as http;



class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Future<Image> fetchImage() async {
  var url = 'http://$server:8000/users/my_profile_picture/'; // replace with your image URL
  var headers = {
    'Authorization': 'Token $token', // replace with your token
  };
  var response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 200) {
    return Image.memory(base64Decode(base64Encode(response.bodyBytes)), height: 70, width: 70,);
  } else {
    throw Exception('Failed to load image');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,    
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: Row(
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
                    const SizedBox(width: 20),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${myProfile!.firstName!} ${myProfile!.lastName!}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Ur account",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditAccountScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Ionicons.chevron_forward_outline),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Language",
                icon: Ionicons.earth,
                bgColor: Colors.blue.shade300,
                iconColor: Colors.white,
                value: "English",
                onTap: () {},
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Notifications",
                icon: Ionicons.notifications,
                bgColor: Colors.blue.shade300,
                iconColor: Colors.white,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Help",
                icon: Ionicons.nuclear,
                bgColor: Colors.blue.shade300,
                iconColor: Colors.white,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
