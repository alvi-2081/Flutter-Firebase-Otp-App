import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import 'package:fluttertoast/fluttertoast.dart';

class OtpScreen extends StatefulWidget {
  String verificationId;
  OtpScreen(this.verificationId, {Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  OtpFieldController otpController = OtpFieldController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Otp Screen",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
          ),
          bottom: PreferredSize(
              child: Text("Enter the OTP here."),
              preferredSize: Size.fromHeight(15)),
          backgroundColor: Colors.white10,
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  // padding: EdgeInsets.symmetric(vertical: 6, horizontal: 35),
                  child: OTPTextField(
                      controller: otpController,
                      length: 6,
                      width: MediaQuery.of(context).size.width * 1,
                      textFieldAlignment: MainAxisAlignment.spaceEvenly,
                      fieldWidth: 42,
                      otpFieldStyle: OtpFieldStyle(
                          focusBorderColor: Colors.grey,
                          enabledBorderColor: Colors.grey),
                      fieldStyle: FieldStyle.box,
                      outlineBorderRadius: 12,
                      obscureText: true,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      onChanged: (pin) {
                        print("Changed: " + pin);
                      },
                      onCompleted: (pin) {
                        verifyOTP(widget.verificationId, pin);
                      }),
                ),
                Container(
                  padding:
                      EdgeInsets.only(bottom: 40, top: 5, left: 38, right: 38),
                  child: Text(
                    "Didn't received a code? Wait for 57 sec",
                    textAlign: TextAlign.left,
                  ),
                )
              ]),
        ));
  }

  void verifyOTP(verificationId, pin) async {
    PhoneAuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: pin);
    try {
      await auth.signInWithCredential(_authCredential).then((value) {
        Fluttertoast.showToast(
            msg: "You are logged in successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(179, 245, 66, 1),
            textColor: Colors.black,
            fontSize: 18.0);
      });
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, gravity: ToastGravity.CENTER);
      return Future.value();
    }
  }
}
