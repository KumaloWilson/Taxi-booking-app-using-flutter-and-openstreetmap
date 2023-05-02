import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class PayFareAmountDialog extends StatefulWidget
{
  double? fareAmount;

  PayFareAmountDialog({this.fareAmount});

  @override
  State<PayFareAmountDialog> createState() => _PayFareAmountDialogState();
}




class _PayFareAmountDialogState extends State<PayFareAmountDialog>
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

            const SizedBox(height: 20,),

            Text(
              "Fare Amount".toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20,),

            const Divider(
              thickness: 4,
              color: Colors.white,
            ),

            const SizedBox(height: 16,),

            Text(
              widget.fareAmount.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 50,
              ),
            ),

            const SizedBox(height: 10,),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "This is the total trip fare amount, Please Pay it to the driver.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                ),
                onPressed: ()
                {
                  Future.delayed(const Duration(milliseconds: 2000), ()
                  {
                    Navigator.pop(context, "cashPayed");
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pay Amount",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Z\$  ${widget.fareAmount!}",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
