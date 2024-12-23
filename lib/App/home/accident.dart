import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main/navigation_bar.dart';

class AccidentPage extends StatefulWidget {
  final int currentAccident;

  const AccidentPage({super.key, required this.currentAccident});

  @override
  State<AccidentPage> createState() => _AccidentPageState();
}

class _AccidentPageState extends State<AccidentPage> {
  final String url = "https://api31-six.vercel.app/rest/";
  List<dynamic>? data;
  bool isLoading = true;
  String? errorMessage;

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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Accident Data'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSecondary),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(
                    myIndex: 1,
                  ),
                ),
              );
            },
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
            title: const Text('Accident Data'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSecondary),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(
                      myIndex: 1,
                    ),
                  ),
                );
              },
            )),
        body: Center(child: Text(errorMessage!)),
      );
    }

    if (data == null || data!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
            title: const Text('Accident Data'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSecondary),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(
                      myIndex: 1,
                    ),
                  ),
                );
              },
            )),
        body: const Center(child: Text('No data available')),
      );
    }

    var item = data!.firstWhere(
      (accident) => accident['pk'] == widget.currentAccident,
      orElse: () => null,
    );

    if (item == null) {
      return Scaffold(
        appBar: AppBar(
            title: const Text('Accident Data'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSecondary),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(
                      myIndex: 1,
                    ),
                  ),
                );
              },
            )),
        body: const Center(child: Text('Accident not found')),
      );
    }

    try {
      final decodedImage = base64Decode(item['images']);

      return Scaffold(
        appBar: AppBar(
          title: const Text('Accident Data'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSecondary),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(
                    myIndex: 1,
                  ),
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Accident ID: ${item['pk']}'),
              ),
              // Image.memory(decodedImage),
              Text('Longitude: ${item['longitude']}'),
              Text('Latitude: ${item['latitude']}'),
              Text('Is Accident: ${item['is_accident']}'),
              Text('Is Fire: ${item['is_fire']}'),
            ],
          ),
        ),
      );
    } catch (e) {
      return Scaffold(
        appBar: AppBar(
            title: const Text('Accident Data'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSecondary),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(
                      myIndex: 1,
                    ),
                  ),
                );
              },
            )),
        body: const Center(child: Text('Invalid image data')),
      );
    }
  }
}
