import 'package:flutter/material.dart';
import 'package:task_manager/screens/on_boarding/login_screen.dart';
import 'package:task_manager/screens/profile/update_profile.dart';
import 'package:task_manager/utility/utility.dart';

class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
  bool isAppBarScreenOpen;

  TMAppBar({
    super.key,
    this.isAppBarScreenOpen = false,
  });

  @override
  State<TMAppBar> createState() => _TMAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TMAppBarState extends State<TMAppBar> {
  Map<String, String> appBarData = {};

  @override
  void initState() {
    super.initState();
    loadAppBarData();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: () {
          if (widget.isAppBarScreenOpen) {
            return;
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateProfile(),
                ));
          }
        },
        child: Row(
          children: [
            _buildCircleAvatar(),
            const SizedBox(width: 12),
            _buildNameEmail(),
            IconButton(
              onPressed: () => onTapLogoutAlert(context),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadAppBarData() async {
    appBarData = await getAppBarData();
    setState(() {});
  }

  CircleAvatar _buildCircleAvatar() {
    return CircleAvatar(
      radius: 20,
      child: ClipOval(
        child: Image.memory(
          showBase64Image(defaultProfilePic),
        ),
      ),
    );
  }

  Expanded _buildNameEmail() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${appBarData['firstName']} ${appBarData['lastName']}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            '${appBarData['email']}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onTapLogoutButton(BuildContext context) async {
    Future<bool> clearData = logout();
    if (await clearData) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  void onTapLogoutAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          MaterialButton(
            onPressed: () => onTapLogoutButton(context),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
