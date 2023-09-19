import 'package:flutter/material.dart';
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";
import 'package:vidshare/widgets/home.dart';
import 'package:vidshare/widgets/new_post.dart';
import 'package:vidshare/widgets/profile_screen.dart';
import 'package:vidshare/widgets/search_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> buildScreens() {
      return [
      
        const HomeScreen(),
        const NewPost(),
        const SearchScreen(),
        const ProfileScreen(),
       
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: ("Home"),
          textStyle: const TextStyle(color: Colors.red),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: const Color.fromARGB(200, 255, 255, 255),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.add_a_photo_rounded),
          inactiveIcon: const Icon(Icons.add_a_photo_outlined),
          title: ("Post"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: const Color.fromARGB(200, 255, 255, 255),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          inactiveIcon: const Icon(Icons.search),
          title: ("Search"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: const Color.fromARGB(200, 255, 255, 255),
        ),
         PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          inactiveIcon: const Icon(Icons.person_outline),
          title: ("Profile"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: const Color.fromARGB(200, 255, 255, 255),
        ),
      ];
    }

    PersistentTabController controller;

    controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(
      context,
      screens: buildScreens(),
      items: navBarsItems(),
      controller: controller,
      confineInSafeArea: true,
      backgroundColor: Colors.black,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: const NavBarDecoration(
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.decelerate,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style9,
    );
  }
}
