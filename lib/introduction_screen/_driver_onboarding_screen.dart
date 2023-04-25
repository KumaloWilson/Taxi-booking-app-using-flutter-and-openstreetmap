import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../splashScreen/splash_screen.dart';
import 'intro_page6.dart';
import 'intro_page7.dart';
import 'intro_page8.dart';



class DriverOnBoardingPage extends StatefulWidget {
  @override
  _DriverOnBoardingPageState createState() => _DriverOnBoardingPageState();
}



class _DriverOnBoardingPageState extends State<DriverOnBoardingPage> {
  final PageController _controller = PageController();


  bool onLastPage = false;

  void permissionRequests()async{
    await Permission.sms.request();
    await Permission.storage.request();
    await Permission.phone.request();
    await Permission.location.request();
  }

  @override
  void initState() {
    super.initState();
    permissionRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index){
              setState(() {
                if(index == 2)
                  {
                    onLastPage = true;
                  }
                else
                  {
                    onLastPage = false;
                  }
              });
            },
            children: const [
              IntroPage6(),
              IntroPage7(),
              IntroPage8()
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.85),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      child: const Text(
                          'Skip',
                        style: TextStyle(
                            color: Color.fromARGB(255, 3, 152, 158),
                            fontWeight: FontWeight.bold

                        ),

                      ),
                      onTap: (){
                          _controller.jumpToPage(7);
                      },
                  ),
                  SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: const ScaleEffect(
                        spacing:  5.0,
                        radius:  4.0,
                          dotColor:  Color.fromARGB(50, 3, 152, 158),
                          activeDotColor:  Color.fromARGB(255, 3, 152, 158),
                      ),
                  ),
                  if (onLastPage == true) GestureDetector(
                    child: const Text(
                        'Done',
                      style: TextStyle(
                          color: Color.fromARGB(255, 3, 152, 158),
                          fontWeight: FontWeight.bold

                      ),
                    ),
                    onTap: () async{

                      final showSelectUserTypeAndOnBoardingScreenPrefs =await SharedPreferences.getInstance();
                      showSelectUserTypeAndOnBoardingScreenPrefs.setBool("ON_BOARDING", false);

                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
                    },
                  ) else GestureDetector(
                    child: const Text('Next',
                      style: TextStyle(
                          color: Color.fromARGB(255, 3, 152, 158),
                          fontWeight: FontWeight.bold

                      ),

                    ),
                    onTap: (){
                       _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubicEmphasized);
                      },
                  )
                  ,
                ],
              )
          )
        ],
      ),
    );
  }
}
