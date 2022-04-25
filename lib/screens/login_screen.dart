import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_auth_practice/screens/otp-screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController phoneController = TextEditingController(text: "+92");

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login Screen",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        bottom: PreferredSize(
            child: Text("We will send you OTP on Number"),
            preferredSize: Size.fromHeight(15)),
        backgroundColor: Colors.white10,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 35),
            child: TextFormField(
              controller: phoneController,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                hintText: "Enter Email or Number",
                labelText: 'Email/Number',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(14)),
                focusedBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                loginWithPhone();
              },
              child: Text(
                'Continue',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 15, horizontal: 110)),
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                            color: Color.fromRGBO(179, 245, 66, 1)))),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(179, 245, 66, 1)),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20, top: 5, left: 38, right: 38),
            child: Text(
              "By Signing up Yo are agreeing to the Company's Privacy Policies and Terms of Use. And allow us to use your information for future Marketing",
              textAlign: TextAlign.justify,
            ),
          )
        ]),
      ),
    );
  }

  void loginWithPhone() async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          Fluttertoast.showToast(
              msg: "Phone number is not Valid", gravity: ToastGravity.CENTER);
        }
      },
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpScreen(verificationId)),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
