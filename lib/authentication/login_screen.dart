import 'package:elrick_trans_app/authentication/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';


class LoginScreen extends StatefulWidget
{

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  String? errorMsg;

  updateLoginTextUserMode() async{

    if(userType == UserType.driver){
      setState(() {
        asUser = 'Driver';
      });
    }

    if(userType == UserType.passenger){
      setState(() {
        asUser = 'Passenger';
      });
    }
  }


  validateForm()
  {
    if(!emailTextEditingController.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "email address is not valid ");
    }

    else if(passwordTextEditingController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Password Field Cannot be empty!");
    }
    else
    {
      loginUserNow();
    }
  }

  loginUserNow() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Please wait...",);
        }
    );

    final User? firebaseUser = (
        await fAuth.signInWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim()
        ).catchError((error) async {
          errorMsg = error.toString();

          print("THIS IS THE EXCEPTION MESSAGE :  $errorMsg");

          Navigator.pop(context);

          if(errorMsg == '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.')
            {
              await Fluttertoast.showToast(msg: "Email account does not exist");
            }

          else if (errorMsg == "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.")
            {
              await Fluttertoast.showToast(msg: "Incorrect password");
            }

          else if(errorMsg == "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.")
            {
              await Fluttertoast.showToast(msg: "Too Many Attempts \nYour account has been temporarily blocked. Please Contact Customer Service");
            }

          else if(errorMsg == "[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.")
            {
              await Fluttertoast.showToast(msg: "Please check your internet access");
            }

          else if(errorMsg == "[firebase_auth/invalid-email] The email address is badly formatted."){
            await Fluttertoast.showToast(msg: "The email address is badly formatted.");
          }
        })
    ).user;

    if(firebaseUser != null && userType == UserType.passenger){
      DatabaseReference passengersRef = FirebaseDatabase.instance.ref().child("users");
      passengersRef.child(firebaseUser.uid).once().then((passengerKey)
      {
        final snap = passengerKey.snapshot;
        if(snap.value != null)
        {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
        }
        else
        {
          Fluttertoast.showToast(msg: "Oops! email does not exist");
          fAuth.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
        }
      });
    }
    else if(firebaseUser != null && userType == UserType.driver) {
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful");
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        }
        else {
          Fluttertoast.showToast(msg: "Oops! email does not exist");
          fAuth.signOut();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        }
      });
    }
    else{
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Invalid email or password!!");
    }

  }

  @override
  void initState() {
    super.initState();
    updateLoginTextUserMode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/Absolute_BG.png"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(
                MediaQuery.of(context).size.height * 0.02
            ),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: const AssetImage('images/Elrik.png'),
                  radius: MediaQuery.of(context).size.height * 0.2,
                ),

                Text(
                  "Login as a $asUser",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),

                TextField(
                  controller: emailTextEditingController,
                  style: const TextStyle(
                      color: Colors.black
                  ),
                  decoration:const InputDecoration(
                    hintText: "Email",
                    fillColor: Colors.white,
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: 11.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),

                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.018,
                ),
                TextField(
                  controller: passwordTextEditingController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration:const InputDecoration(
                    hintText: "Password",
                    fillColor: Colors.white,
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: 11.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),
                  ),                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                ElevatedButton(
                  onPressed: ()
                  {
                    validateForm();
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: const StadiumBorder(),
                    side: BorderSide(
                        color: primaryColor,
                        width: 2
                    ),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.008,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: const CircleBorder(), //<-- SEE HERE
                                padding: const EdgeInsets.all(10),
                              ),
                              child: Image.asset(
                                'images/google.png',
                                width: MediaQuery.of(context).size.width* 0.065,
                              )
                          ),

                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: const CircleBorder(), //<-- SEE HERE
                              padding: const EdgeInsets.all(10),
                            ),
                            child: Image.asset(
                             'images/facebook.png',
                              width: MediaQuery.of(context).size.width* 0.065,
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),


                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Column(
                  children: [
                    GestureDetector(
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                        )
                    ),

                    GestureDetector(
                        onTap: ()
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (c)=> SignUpScreen()));
                        },
                        child: const Text(
                          "Don't have an Account? Register Here",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          ),
                        )
                    )
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
