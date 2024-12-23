import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main/navigation_bar.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {

  @override
  void initState() {
    super.initState();
  }


  Future<void> launchURL(Uri updateUrl) async {
    try {
      if (await canLaunchUrl(updateUrl)) {
        await launchUrl(updateUrl);
      } else {
        print('Could not launch the provided URL.');
      }
    } catch (e) {
      print('An error occurred while trying to launch the URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(myIndex: 2),
          ),
        );
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
                  builder: (context) => const Home(myIndex: 2),
                ),
              );
            },
          ),
          title: Text('IVision Team',style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
            ),),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Mobile Application Developer:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  Text(
                    'Marwan Ahmed Abdel Rahim',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      launchURL(Uri(
                        scheme: 'https',
                        host: 'www.linkedin.com',
                        path: 'in/marwan-ahmed-abdelrehem/',
                      ));
                    },
                    child: const Text(
                      'Contact',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text(
                    '----------',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Desktop Application Developer:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  Text(
                    'Youssef Walid Saeed',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      launchURL(Uri(
                        scheme: 'https',
                        host: 'www.linkedin.com',
                        path: 'in/youssef-walid-8a06b8281/',
                      ));
                    },
                    child: const Text(
                      'Contact',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Youssef Tamer Moaaz',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      launchURL(Uri(
                        scheme: 'https',
                        host: 'www.linkedin.com',
                        path: 'in/yousseftamerv1/',
                      ));
                    },
                    child: const Text(
                      'Contact',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text(
                    '----------',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'AI Model:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  Text(
                    'Hassan Mohammed Hassan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      launchURL(Uri(
                        scheme: 'https',
                        host: 'www.linkedin.com',
                        path: 'in/hassan-mohamed-519a0427a/',
                      ));
                    },
                    child: const Text(
                      'Contact',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Omar Adel Hanafi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      launchURL(Uri(
                        scheme: 'https',
                        host: 'www.linkedin.com',
                        path: 'in/omar-adel-733b3229a/',
                      ));
                    },
                    child: const Text(
                      'Contact',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text(
                    '----------',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'API:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  Text(
                    'Abdallah Shrief Mohammed',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      launchURL(Uri(
                        scheme: 'https',
                        host: 'www.linkedin.com',
                        path: 'in/abdallh-shref-b91b92329/',
                      ));
                    },
                    child: const Text(
                      'Contact',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text(
                    '----------',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Project Hardware:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  Text(
                    'Islam Ahmed Sayed',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      launchURL(Uri(
                        scheme: 'https',
                        host: 'www.linkedin.com',
                        path: 'in/islam-ahmed-1aa1692a6/',
                      ));
                    },
                    child: const Text(
                      'Contact',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text(
                    '----------',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Project Simulation:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  Text(
                    'Abdul Rahman Mahdi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      launchURL(Uri(
                        scheme: 'https',
                        host: 'www.linkedin.com',
                        path: 'in/abdelrahman-mahdy-57048030a/',
                      ));
                    },
                    child: const Text(
                      'Contact',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
