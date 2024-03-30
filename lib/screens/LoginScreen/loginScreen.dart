import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_connect/screens/OtpScreen/otpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;
  bool _isButtonClicked = false;
  bool _isLoading = false;
  TextEditingController _mobileNumberController = TextEditingController();

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    String formattedPhoneNumber = '+91$phoneNumber';

    setState(() {
      _isLoading = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: formattedPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        Get.to(() => OtpScreen(
              mobileNumber: formattedPhoneNumber,
              verificationId: verificationId,
            ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 130, left: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: const DefaultTextStyle(
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 21,
                                    fontFamily: "cirka",
                                  ),
                                  child: Text(
                                    "Membership Application",
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: const DefaultTextStyle(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontFamily: "gilroy",
                                  ),
                                  child: Text(
                                    "Tell us your mobile number",
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 128,
                              ),
                              Center(
                                child:
                                    Image.asset("assets/images/train.gif"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 45,
                      child: TextFormField(
                        controller: _mobileNumberController,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(
                          labelText: "Mobile Number",
                          prefixText: '+91 ',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontFamily: "gilroy", 
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          counterText: null,
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: "gilroy",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (value) {
                              setState(() {
                                _isChecked = value!;
                                _isButtonClicked = _isChecked;
                              });
                            },
                            activeColor: Colors.black,
                          ),
                          Text(
                            'I agree to the terms and conditions',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "gilroy",
                              color: _isChecked ? Colors.black : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 45,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isChecked
                            ? () {
                                if (_mobileNumberController.text.isNotEmpty) {
                                  _verifyPhoneNumber(
                                      _mobileNumberController.text);
                                }
                              }
                            : null,
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: "gilroy",
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isButtonClicked
                              ? Colors.black
                              : Colors.grey.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              color: Colors.transparent,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
