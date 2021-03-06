import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/user_authentication_screen.dart';
import '../providers/entry_authentication.dart';
import '../screens/profile_screen.dart';
import '../screens/about_screen.dart';
import '../screens/admin_screen.dart';
import '../screens/home_screen.dart';
import '../screens/input_output_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  Widget _buildDrawer({
    required Icon icon,
    required String title,
    required void Function() onTap,
  }) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(fontSize: 20.0),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuthOperation =
        Provider.of<FirebaseAuthenticationHandler>(context, listen: false);
    return Drawer(
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              const Image(
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                image: AssetImage('assets/images/background_2.jpg'),
              ),
              Positioned(
                  bottom: 20.0,
                  left: 20.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: const ClipOval(
                          child: Image(
                            image: AssetImage('assets/images/sorting.PNG'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 6.0,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${firebaseAuthOperation.loggedInUser.firstname.toUpperCase()}\n'
                          '${firebaseAuthOperation.loggedInUser.lastname.toUpperCase()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ))
            ],
          ),
          _buildDrawer(
            icon: const Icon(Icons.home),
            title: 'Home',
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(HomeScreen.routeName),
          ),
          // _buildDrawer(
          //   icon: const Icon(Icons.output),
          //   title: 'I/O Status',
          //   onTap: () => Navigator.of(context)
          //       .pushReplacementNamed(InputOutputScreen.routeName),
          // ),
          _buildDrawer(
            icon: const Icon(Icons.account_circle),
            title: 'Your Profile',
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ProfileScreen.routeName, arguments: {
              'current_user': firebaseAuthOperation.loggedInUser,
            }),
          ),
          _buildDrawer(
            icon: const Icon(Icons.chat),
            title: 'About',
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(AboutScreen.routeName),
          ),
          if (firebaseAuthOperation.loggedInUser.isAdmin)
            _buildDrawer(
              icon: const Icon(Icons.chat),
              title: 'Admin',
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(AdminScreen.routeName, arguments: {
                'current_user': firebaseAuthOperation.loggedInUser,
                'users_data': firebaseAuthOperation.usersData,
              }),
            ),
          Expanded(
              child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: _buildDrawer(
              icon: const Icon(Icons.logout),
              title: 'Logout',
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => const UserAuthenticationScreen(),
                ));

                firebaseAuthOperation.logout();
              },
            ),
          )),
        ],
      ),
    );
  }
}
