import 'package:accident_tracker/App/account/update_password_page.dart';
import 'package:accident_tracker/App/account/edit_profile_page.dart';
import 'package:accident_tracker/App/auth/auth_page.dart';
import 'package:accident_tracker/App/main/loading_page.dart';
import 'package:accident_tracker/flavors.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final GlobalKey _editProfile = GlobalKey();
  final GlobalKey _changePassword = GlobalKey();
  bool isDuty = false;
  bool loaded = false;
  Object? unitId;

  @override
  void initState() {
    super.initState();
    F.appFlavor == Flavor.unit ? _loadUnitSettings() : null;
    _createTutorial();
  }

  Future<void> _loadUnitSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loadDutySettings();
    setState(() {
      unitId = prefs.getString('unit_Id') ?? false;
      loaded = true;
    });
  }

  Future<void> _loadDutySettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDuty = prefs.getBool('unit_duty') ?? false;
    });
  }

  Future<void> _saveDutySettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('unit_duty', isDuty);
  }

  void _createTutorial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasShownTutorial = prefs.getBool('hasShownTutorial2');

    if (hasShownTutorial != true) {
      final targets = [
        TargetFocus(
          identify: 'Edit Profile',
          keyTarget: _editProfile,
          enableOverlayTab: true,
          alignSkip: Alignment.bottomCenter,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15),
                  Text(
                    "Edit Profile",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Edit your profile information from here.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'Change Password',
          keyTarget: _changePassword,
          enableOverlayTab: true,
          alignSkip: Alignment.bottomCenter,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 65),
                  Text(
                    "Change Password",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "You can change your password from a link that will be sent to your email.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ];

      final tutorial = TutorialCoachMark(targets: targets);
      await Future.delayed(const Duration(milliseconds: 500));
      tutorial.show(context: context);

      await prefs.setBool('hasShownTutorial2', true);
    }
  }

  Future<void> onProfileTapped(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child('profile_images/${user.uid}');
      await firebaseStorageRef.putFile(File(image.path));

      final imageUrl = await firebaseStorageRef.getDownloadURL();
      await user.updateProfile(
          displayName: user.displayName, photoURL: imageUrl);
      await FirebaseAuth.instance.currentUser!.reload();

      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          backgroundColor: Color.fromARGB(255, 41, 221, 86),
          title: Center(
            child: Text(
              'Profile Picture Updated',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoadingPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (user != null) ...[
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfile(),
                        ),
                      );
                    },
                    icon: CircleAvatar(
                      radius: 50,
                      backgroundImage: user.photoURL != null
                          ? NetworkImage(user.photoURL!)
                          : const AssetImage('assets/profile_pic_purple.png')
                              as ImageProvider,
                    ),
                  ),
                  Text(
                    user.displayName ?? 'User',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Profile Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  F.appFlavor == Flavor.unit
                      ? Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(11.0),
                          ),
                          child: ListTile(
                            tileColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 6.0),
                            leading: loaded
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      color: isDuty
                                          ? const Color.fromARGB(255, 0, 255, 8)
                                          : const Color.fromARGB(
                                              255, 255, 17, 0),
                                    ),
                                  )
                                : Container(
                                    width: 30,
                                    height: 30,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                loaded
                                    ? Text(
                                        'U${unitId.toString()}',
                                      )
                                    : const SizedBox(),
                                loaded
                                    ? Switch(
                                        value: isDuty,
                                        onChanged: (value) {
                                          setState(() {
                                            isDuty = value;
                                          });
                                          _saveDutySettings();
                                        },
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(11.0),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfile(),
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 6.0),
                      leading: Image.asset('assets/edit profile.png'),
                      title: Center(
                        child: Text(
                          key: _editProfile,
                          'Edit Profile',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(11.0),
                      ),
                      child: FirebaseAuth.instance.currentUser!.emailVerified
                          ? ListTile(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const UpdatePassword(),
                                  ),
                                );
                              },
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 6.0),
                              leading:
                                  Image.asset('assets/change password.png'),
                              title: Center(
                                child: Text(
                                  key: _changePassword,
                                  'Change Password',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            )
                          : Container()),
                  const SizedBox(height: 10),
                ] else
                  const Text(
                    'User not signed in',
                    style: TextStyle(fontSize: 18),
                  ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                  child: ListTile(
                    onTap: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthPage(),
                        ),
                      );
                      await FirebaseAuth.instance.signOut();
                      await GoogleSignIn().signOut();
                    },
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 1.0),
                    leading: Image.asset('assets/logout-icon.png'),
                    title: const Center(
                      child: Text(
                        "LOG OUT",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 17, 0),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
