// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  const MyDrawer({
    Key? key,
    required this.onProfileTap,
    required this.onSignOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //header
          Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              //home list tile
              MyListTile(
                iconData: Icons.home,
                text: 'H O M E',
                onTap: () => Navigator.pop(context),
              ),

              //profile lsit tile

              MyListTile(
                iconData: Icons.person,
                text: 'P R O F I L E',
                onTap: () => onProfileTap,
              ),
            ],
          ),

          //logotut list tile
          Padding(
            padding: const EdgeInsets.only(
              bottom: 25.00,
            ),
            child: MyListTile(
              iconData: Icons.logout_outlined,
              text: 'L O G O U T',
              onTap: () => onSignOut,
            ),
          ),
        ],
      ),
    );
  }
}
