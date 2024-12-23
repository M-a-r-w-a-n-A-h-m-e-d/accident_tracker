import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:accident_tracker/App/home/report_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import '../main/navigation_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'accident.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final String url = "https://api31-six.vercel.app/rest/";
  List<dynamic>? data;
  bool isLoading = true;
  String? errorMessage;
  final GlobalKey _map = GlobalKey();
  final GlobalKey _report = GlobalKey();

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          final decodedData = json.decode(response.body);
          if (decodedData is List) {
            data = decodedData;
          } else if (decodedData is Map) {
            data = [decodedData];
          }
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to load data: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
      debugPrint("Fetch error: $e");
    }
  }

  void _createTutorial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasShownTutorial = prefs.getBool('hasShownTutorial1');

    if (hasShownTutorial != true) {
      final targets = [
        TargetFocus(
          identify: 'Maps',
          keyTarget: _map,
          enableOverlayTab: true,
          alignSkip: Alignment.bottomCenter,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Google Maps",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Here you will see all the information you need and you can use it as a Google Maps app with new features.",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        TargetFocus(
          identify: 'Report',
          keyTarget: _report,
          enableOverlayTab: true,
          alignSkip: Alignment.bottomCenter,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Report For An Accident",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Here you can report an accident and help save people.",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ];

      final tutorial = TutorialCoachMark(targets: targets);
      tutorial.show(context: context);
      await prefs.setBool('hasShownTutorial1', true);
    }
  }

  @override
  void initState() {
    super.initState();
    _createTutorial();
    fetchData();
  }

  void vibrating() async {
    Vibration.vibrate();
    await Future.delayed(const Duration(milliseconds: 500));
    Vibration.vibrate();
  }

  @override
  Widget build(BuildContext context) {
    // Filter data for accidents with IsAcc == true
    var filteredData =
        data?.where((accident) => accident['is_accident'] == true).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 27),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(myIndex: 0),
                          ),
                        );
                      },
                      icon: CircleAvatar(
                        radius: 25,
                        backgroundImage: user!.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : const AssetImage('assets/profile_pic_purple.png')
                                as ImageProvider,
                      ),
                    ),
                    Text(
                      'Hi, ${user!.displayName ?? 'User'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      key: _report,
                      onPressed: () async {
                        final status = await Permission.camera.request();
                        if (!status.isGranted) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                backgroundColor: Colors.red,
                                title: Center(
                                  child: Text(
                                    'Application will not work completely without permission.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (status.isGranted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReportAccident(),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.report_gmailerrorred_outlined),
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  'Location',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              Container(
                key: _map,
                height: 450,
                margin: const EdgeInsets.all(10),
                child: FlutterMap(
                  options: const MapOptions(
                    initialCenter: LatLng(30.045704, 31.178611),
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: const LatLng(30.045699, 31.178588),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            onPressed: () {},
                            icon: const Icon(Icons.location_on, size: 40),
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(child: Text(errorMessage!))
                      : filteredData != null && filteredData.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  borderOnForeground: false,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        padding: const EdgeInsets.all(5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AccidentPage(
                                              currentAccident:
                                                  filteredData[index]['pk'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Location',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text('No Accidents'),
                            ),
            ],
          ),
        ),
      ),
    );
  }
}
