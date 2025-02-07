import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  void profilebutton() {
    //implementing profile button task
  }
  void notificationbutton() {
    //implementing notification button task
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        children: [
          Text(
            "Hi, Rahul",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 140,
          ),
          GestureDetector(
            onTap: () {
              profilebutton();
            },
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              notificationbutton();
            },
            child: Icon(
              Icons.notifications,
              color: Color(0xFF90EE90),
              size: 30,
            ),
          )
        ],
      ),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Color(0xFF90EE90),
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
