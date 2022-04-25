import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_auth_practice/screens/otp-screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController phoneController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login Screen",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: Colors.white10,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
          top: true,
          child: Expanded(
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
                    // prefixIcon: Icon(
                    //   Icons.email,
                    //   color: Colors.indigo[600],
                    // ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(14)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  // validator: MultiValidator([
                  //   RequiredValidator(errorText: "Required *"),
                  //   EmailValidator(errorText: "Not A Valid Email"),
                  // ]
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                // height: 50,
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
                padding:
                    EdgeInsets.only(bottom: 20, top: 5, left: 38, right: 38),
                child: Text(
                  "By Signing up Yo are agreeing to the Company's Privacy Policies and Terms of Use. And allow us to use your information for future Marketing",
                  textAlign: TextAlign.justify,
                ),
              )
            ]),
          )),
    );
  }

  void loginWithPhone() async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        // .then((value) {
        //  }
        // );
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
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
