import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:accident_tracker/common/Widgets/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../main/loading_page.dart';
import 'dart:io';

import '../main/navigation_bar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final User? user = FirebaseAuth.instance.currentUser;
  final nameController = TextEditingController();
  final GlobalKey _profilePicKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _createTutorial();
  }

  void _createTutorial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasShownTutorial = prefs.getBool('hasShownTutorial3');

    if (hasShownTutorial != true) {
      final targets = [
        TargetFocus(
          identify: 'Profile Picture',
          keyTarget: _profilePicKey,
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
                    "Profile Picture",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Upload your profile picture from here.",
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
      tutorial.show(context: context);
      await prefs.setBool('hasShownTutorial3', true);
    }
  }

  Future<void> onProfileTapped(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      if (user == null) return;

      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child('profile_images/${user!.uid}');
      await firebaseStorageRef.putFile(File(image.path));

      final imageUrl = await firebaseStorageRef.getDownloadURL();
      await user!
          .updateProfile(displayName: user!.displayName, photoURL: imageUrl);
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
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoadingPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Home(myIndex: 0)));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSecondary),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Home(myIndex: 0)));
            },
          ),
          title: Text(
            'Edit Profile',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          titleTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              IconButton(
                key: _profilePicKey,
                onPressed: () => onProfileTapped(context),
                icon: CircleAvatar(
                  radius: 50,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : const AssetImage('assets/profile_pic_purple.png')
                          as ImageProvider,
                ),
              ),
              const SizedBox(height: 70),
              MyTextField(
                controller: nameController,
                label: 'Name',
                obscureText: false,
                prefixIcon: const Icon(Icons.person),
              ),
              const SizedBox(height: 200),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty) {
                    user?.updateDisplayName(nameController.text);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          backgroundColor: Colors.green,
                          title: Center(
                            child: Text(
                              'Updated Successfully',
                              style: TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          backgroundColor: Colors.red,
                          title: Center(
                            child: Text(
                              'Failed to Update',
                              style: TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 110, vertical: 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Update Profile',
                  style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
