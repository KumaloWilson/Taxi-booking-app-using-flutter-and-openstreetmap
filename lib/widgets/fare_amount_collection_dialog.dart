import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../global/global.dart';


class FareAmountCollectionDialog extends StatefulWidget
{
  double? totalFareAmount;

  FareAmountCollectionDialog({super.key, this.totalFareAmount});

  @override
  State<FareAmountCollectionDialog> createState() => _FareAmountCollectionDialogState();
}




class _FareAmountCollectionDialogState extends State<FareAmountCollectionDialog>
{
  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      backgroundColor: Colors.grey,
      child: Container(
        margin: const EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),

            Text(
              "Trip Fare Amount (${driverVehicleType!.toUpperCase()})",
              style:TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),


            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),

            const Divider(
              thickness: 4,
              color: Colors.white,
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            Text(
              widget.totalFareAmount.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.18,
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "This is the total trip amount, Please it Collect from user.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor
              ),
              onPressed: ()
              {
                Future.delayed(const Duration(milliseconds: 2000), ()
                {
                  SystemNavigator.pop();
                });
              },
              child: const Text(
                "Collect Cash",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 4,),

          ],
        ),
      ),
    );
  }
}
