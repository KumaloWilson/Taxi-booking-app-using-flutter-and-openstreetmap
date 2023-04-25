import 'package:elrick_trans_app/authentication/car_info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget
{
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
{
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm()
  {
    if(nameTextEditingController.text.length < 3)
      {
        Fluttertoast.showToast(msg: "name must be atleast 3 letters long");
      }
    else if(!emailTextEditingController.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "email address should contain '@' ");
    }
    else if(phoneTextEditingController.text.isEmpty)
      {
        Fluttertoast.showToast(msg: "Phone Number is required.");
      }

    else if(passwordTextEditingController.text.length < 8)
      {
        Fluttertoast.showToast(msg: "password should contain at least 8 characters");
      }
    else
      {
        saveUserInfoNow();
      }
  }

  saveUserInfoNow() async
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
        await fAuth.createUserWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim()
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "ERROR: $msg");
        })
    ).user;

    if(firebaseUser != null && userType == UserType.passenger)
      {
        Map userMap =
            {
              "id": firebaseUser.uid,
              "name": nameTextEditingController.text.trim(),
              "email": emailTextEditingController.text.trim(),
              "phone": phoneTextEditingController.text.trim(),
            };
        DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
        usersRef.child(firebaseUser.uid).set(userMap);

        currentFirebaseUser = firebaseUser;
        Fluttertoast.showToast(msg: "Account has been created successfully");
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
      }

    else if(firebaseUser != null && userType == UserType.driver)
    {
      Map userMap =
      {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("drivers");
      usersRef.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been created successfully");
      Navigator.push(context, MaterialPageRoute(builder: (c)=> CarInfoScreen()));
    }

    else
      {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Account creation unsuccessful. Please Retry!!");
      }

  }



  @override
  Widget build(BuildContext context)
  {
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
                  radius: MediaQuery.of(context).size.height * 0.175,
                ),

                Text(
                  "$asUser Registration",
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
                  controller: nameTextEditingController,
                  style: const TextStyle(
                      color: Colors.black
                  ),
                  decoration:const InputDecoration(
                    hintText: "Name",
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
                  height: MediaQuery.of(context).size.height * 0.01,
                ),

                TextField(
                  controller: emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
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
                  height: MediaQuery.of(context).size.height * 0.01,
                ),

                TextField(
                  controller: phoneTextEditingController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                      color: Colors.black
                  ),
                  decoration:const InputDecoration(
                    hintText: "Phone Number",
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
                  height: MediaQuery.of(context).size.height * 0.01,
                ),

                TextField(
                  controller: passwordTextEditingController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: const TextStyle(
                      color: Colors.black
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

                  ),
                ),

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
                    "Register",
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

                          ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 3, 152, 158),
                                shape: const CircleBorder(), //<-- SEE HERE
                                padding: const EdgeInsets.all(10),
                              ),
                              child: Image.asset(
                                'images/google.png',
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
                        onTap: ()
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                        },
                        child: const Text(
                          "Already have an Account? Login Here",
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
