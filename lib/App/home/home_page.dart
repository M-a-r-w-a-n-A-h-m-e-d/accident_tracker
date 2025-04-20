import 'dart:async';
import 'dart:developer';
import 'package:accident_tracker/flavors.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:accident_tracker/App/home/report_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../main/navigation_bar.dart';
import 'accident.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final String url = "https://api31-six.vercel.app/rest/";
  List<dynamic>? data;
  String? errorMessage;
  final GlobalKey _map = GlobalKey();
  final GlobalKey _report = GlobalKey();
  Timer? _timer;
  Object? unitId;
  bool isLoading = true;
  bool loaded = false;
   bool isShowen = false;
  String alertData = '';
  bool isDuty = false;
  int cameraId = -1;
  List<dynamic> cameraLocation = [];

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

  // Fetch data every 5 seconds
  Future<void> fetchData(bool fromApi) async {
    try {
      if (fromApi) {
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
            errorMessage = 'Failed to load data: ${response.statusCode}';
            isLoading = false;
          });
        }
      } else {
        fetchUnitData(int.parse(unitId.toString()));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "Error: $e";
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchUnitData(int unitId) async {
    try {
      // Reference to the specific unit in the Firebase Database
      var _databaseReference = FirebaseDatabase.instance.ref('/$unitId');

      // Fetch data once from the database
      DataSnapshot unitDataSnapshot = await _databaseReference.get();

      // Log the fetched data for debugging purposes
      log('Fetched Unit Data: ${unitDataSnapshot.value.toString()}');

      // Check if the data is available and not null
      if (unitDataSnapshot.exists) {
        // Retrieve the data as a Map
        Map<String, dynamic> unitData =
            Map<String, dynamic>.from(unitDataSnapshot.value as Map);

        // Extract the variables from the Map
        var unitLocation = unitData['unit_location'] ?? {};
        var lat = unitLocation['lat'] ?? 0.0;
        var long = unitLocation['long'] ?? 0.0;
        isDuty = unitData['on_duty'] ?? false;
        cameraId = unitData['camera_id'] ?? 0;
        cameraLocation = unitData['camera_location'] ?? [];
        bool needEmergency = unitData['need_emergency'] ?? false;
        var unitIdFromDb = unitData['unit_id'] ?? 0;

        // Log the extracted variables for debugging purposes
        log('Unit Location: Lat: $lat, Long: $long');
        log('On Duty: $isDuty');
        log('Camera ID: $cameraId');
        log('Camera Location: $cameraLocation');
        log('Need Emergency: $needEmergency');
        log('Unit ID: $unitIdFromDb');
        if ((cameraId != -1 && cameraLocation.isNotEmpty) && !isShowen) {
          showDialog(
            context: context,
            barrierDismissible: false, // Prevent dismissing by tapping outside
            builder: (context) {
              return AlertDialog(
                title: const Text('Go to Specific Camera'),
                content: const Text(
                  'You have been assigned to go to a specific camera location. Do you accept?',
                ),
                actions: [
                  // Decline Button
                  TextButton(
                    onPressed: () {
                      updateUnitLocation(int.parse(unitId.toString()));
                      Navigator.pop(context); // Close the dialog
                      setState(() {
                        alertData = 'Declined';
                      });
                    },
                    child: const Text('Decline'),
                  ),
                  // Accept Button
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      setState(() {
                        alertData = 'Accepted';
                      });
                    },
                    child: const Text('Accept'),
                  ),
                ],
              );
            },
          );
          isShowen = true;
        }

        if (mounted) {
          setState(() {
            isLoading = false; // Stop loading after data is fetched
            
          });
        }
      } else {
        log('No data found for unit $unitId');
      }
    } catch (e) {
      // Catch and log any errors
      log('Error fetching unit data: $e');
    }
  }

  void showCameraAlert(
      BuildContext context) {
    // Show the alert dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return AlertDialog(
          title: const Text('Go to Specific Camera'),
          content: const Text(
            'You have been assigned to go to a specific camera location. Do you accept?',
          ),
          actions: [
            // Decline Button
            TextButton(
              onPressed: () {
                updateUnitLocation(int.parse(unitId.toString()));
                Navigator.pop(context); // Close the dialog
                setState(() {
                  alertData = 'Declined';
                });
              },
              child: const Text('Decline'),
            ),
            // Accept Button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                 setState(() {
                  alertData = 'Accepted';
                });
              },
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateUnitLocation(int unitId) async {
    DatabaseReference unitRef = FirebaseDatabase.instance.ref('/$unitId');

    try {
      await unitRef.update({
        'camera_id': -1,
      });
      log('Unit data updated successfully');
    } catch (e) {
      log('Error updating data: $e');
    }
  }

  void startFetchingData() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      F.appFlavor == Flavor.unit ? fetchData(false) : fetchData(true);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUnitSettings();
    _createTutorial();
    F.appFlavor == Flavor.unit ? null : fetchData(true);
    startFetchingData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                      'Here you will see all the information you need and you can use it as a Google Maps app with new features.',
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
                      "Here you can report an accident and help to save people.",
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

  void vibrating() async {
    Vibration.vibrate();
    await Future.delayed(const Duration(milliseconds: 500));
    Vibration.vibrate();
  }

  @override
  Widget build(BuildContext context) {
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
                      color: const Color.fromARGB(255, 255, 17, 0),
                    ),
                  ],
                ),
              ),
              SizedBox(
                key: _map,
                height: 500,
                child: FlutterMap(
                  options: const MapOptions(
                    initialCenter: LatLng(30.045704, 31.178611),
                    initialZoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}",
                    ),
                    MarkerLayer(
                      markers: [
                        // Add markers for filtered accidents
                        for (var i in filteredData ?? [])
                          Marker(
                            width: 40,
                            height: 40,
                            point: LatLng(i['latitude'], i['longitude']),
                            child: IconButton(
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AccidentPage(
                                      currentAccident: i['pk'],
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.location_on,
                                size: 30,
                              ),
                              color: Colors.red,
                            ),
                          ),
                        if (cameraId != 0 && cameraLocation.isNotEmpty)
                          Marker(
                            width: 40,
                            height: 40,
                            point: LatLng(cameraLocation[0], cameraLocation[1]),
                            child: IconButton(
                              highlightColor: Colors.transparent,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 30,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              F.appFlavor == Flavor.development
                  ? isLoading
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      borderOnForeground: false,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            enableFeedback: false,
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
                                                builder: (context) =>
                                                    AccidentPage(
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
                                )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
