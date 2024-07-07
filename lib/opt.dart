import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:int/globals.dart';
import 'package:int/login.dart';
import 'package:int/signup.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPage extends StatelessWidget {
  TextEditingController _otpController = TextEditingController();
  String email = '';

  OtpPage({required this.email});

  Future<String?> verify_password(String email, String code) async {
  var url = Uri.parse('http://${server}:8000/users/verify_password/');
  final response = await post(url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'email': email,
        'code': code,
      }));
  Map data = json.decode(response.body);
  return data['email'];
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text('Enter the OTP sent to your number', style: TextStyle(fontSize: 18)),
            SizedBox(height: 50),
            PinCodeTextField(
              appContext: context,
              length: 5,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.grey[300],
              ),
              animationDuration: Duration(milliseconds: 300),
              controller: _otpController,
              onChanged: (value) {
               
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String code = _otpController.text.trim();
                print(code);
                String? mail = await verify_password(email, code);
                print(mail);
                if (mail != null && mail != ''){
                  Navigator.push(
                context,
                  MaterialPageRoute(builder: (context) => login()),
              );
                }
                

              },
              child: Text('Verify', style: TextStyle(color: Colors.blue)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // button shape
              ),
            ),
          ],
        ),
      ),
    );
  }
}