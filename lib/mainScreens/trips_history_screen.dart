import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';
import '../widgets/history_design_ui.dart';


class TripsHistoryScreen extends StatefulWidget
{
  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreenState();
}




class _TripsHistoryScreenState extends State<TripsHistoryScreen>
{
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
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
                "Trips History"
            ),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: ()
              {
                SystemNavigator.pop();
              },
            ),
          ),
          body: ListView.separated(
            separatorBuilder: (context, i)=> const Divider(
              color: Colors.grey,
              thickness: 2,
              height: 2,
            ),
            itemBuilder: (context, i)
            {
              return Card(
                color: Colors.white54,
                child: HistoryDesignUIWidget(
                  tripsHistoryModel: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList[i],
                ),
              );
            },
            itemCount: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
          ),
        )


    );

  }
}
