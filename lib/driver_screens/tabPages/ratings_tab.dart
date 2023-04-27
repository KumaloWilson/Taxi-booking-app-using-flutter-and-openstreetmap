import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../../global/global.dart';
import '../../infoHandler/info_handler.dart';


class RatingsTabPage extends StatefulWidget
{
  const RatingsTabPage({Key? key}) : super(key: key);

  @override
  State<RatingsTabPage> createState() => _RatingsTabPageState();
}




class _RatingsTabPageState extends State<RatingsTabPage>
{
  double ratingsNumber=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getRatingsNumber();
  }

  getRatingsNumber()
  {
    setState(() {
      ratingsNumber = double.parse(Provider.of<AppInfo>(context, listen: false).driverAverageRatings);
    });

    setupRatingsTitle();
  }

  setupRatingsTitle()
  {
    if(ratingsNumber == 1)
    {
      setState(() {
        titleStarsRating = "Very Bad";
      });
    }
    if(ratingsNumber == 2)
    {
      setState(() {
        titleStarsRating = "Bad";
      });
    }
    if(ratingsNumber == 3)
    {
      setState(() {
        titleStarsRating = "Good";
      });
    }
    if(ratingsNumber == 4)
    {
      setState(() {
        titleStarsRating = "Very Good";
      });
    }
    if(ratingsNumber == 5)
    {
      setState(() {
        titleStarsRating = "Excellent";
      });
    }
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
        body: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Colors.black54,
          child: Container(
            margin: const EdgeInsets.all(8),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const SizedBox(height: 22.0,),

                const Text(
                  "Average Ratings:",
                  style: TextStyle(
                    fontSize: 22,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 22.0,),

                const Divider(
                  thickness: 4,
                  color: Colors.white,
                ),

                const SizedBox(height: 22.0,),

                SmoothStarRating(
                  rating: ratingsNumber,
                  allowHalfRating: false,
                  starCount: 5,
                  color: Colors.amber,
                  borderColor: Colors.amber,
                  size: 46,
                ),

                const SizedBox(height: 12.0,),

                Text(
                  titleStarsRating,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),

                const SizedBox(height: 18.0,),

              ],
            ),
          ),
        ),
      ),

    );
  }
}
