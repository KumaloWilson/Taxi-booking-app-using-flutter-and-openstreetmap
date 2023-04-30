import 'package:elrick_trans_app/global/global.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget
{
  String? message;

  ProgressDialog({this.message});


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),

              CircularProgressIndicator(
                valueColor:  AlwaysStoppedAnimation<Color>(primaryColor),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Text(
                message!,
                style:  TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width*0.04,
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
