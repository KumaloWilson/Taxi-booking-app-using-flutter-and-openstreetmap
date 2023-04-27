import 'package:elrick_trans_app/driver_screens/tabPages/earning_tab.dart';
import 'package:elrick_trans_app/driver_screens/tabPages/home_tab.dart';
import 'package:elrick_trans_app/driver_screens/tabPages/profile_tab.dart';
import 'package:elrick_trans_app/driver_screens/tabPages/ratings_tab.dart';
import 'package:flutter/material.dart';

class DriverHomeScreen extends StatefulWidget
{
  const DriverHomeScreen({super.key});


  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}


class _DriverHomeScreenState extends State<DriverHomeScreen> with SingleTickerProviderStateMixin
{

  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index)
  {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState()
  {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          HomeTabPage(),
          EarningsTabPage(),
          RatingsTabPage(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [

          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: "Earnings"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Ratings"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Account"
          ),

        ],
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.yellow,
        backgroundColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }

}
