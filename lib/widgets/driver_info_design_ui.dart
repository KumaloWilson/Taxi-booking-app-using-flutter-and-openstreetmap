import 'package:flutter/material.dart';


class InfoDesignUIWidget extends StatefulWidget
{
  String? textInfo;
  IconData? iconData;

  InfoDesignUIWidget({this.textInfo, this.iconData});

  @override
  State<InfoDesignUIWidget> createState() => _InfoDesignUIWidgetState();
}




class _InfoDesignUIWidgetState extends State<InfoDesignUIWidget>
{
  @override
  Widget build(BuildContext context)
  {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: ListTile(
        leading: Icon(
          widget.iconData,
          color: Colors.black,
        ),
        title: Text(
          widget.textInfo!,
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
