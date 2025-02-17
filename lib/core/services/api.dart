import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  DataScreenState createState() => DataScreenState();
}

class DataScreenState extends State<DataScreen> {
  final String url = "https://api31-six.vercel.app/rest/";
  List<dynamic>? data;
  bool isLoading = true;
  String? errorMessage;

  // Function to fetch data from a given URL
  Future<void> fetchData(String url) async {
    try {
      // Make an HTTP GET request to the provided URL
      final response = await http.get(Uri.parse(url));

      // Check if the response status code is 200 (success)
      if (response.statusCode == 200) {
        setState(() {
          // Decode the response body (JSON format)
          final decodedData = json.decode(response.body);

          // Check if the decoded data is a List or Map and update 'data'
          if (decodedData is List) {
            data = decodedData; // If it's a List, directly assign to data
          } else if (decodedData is Map) {
            data = [decodedData]; // If it's a Map, wrap it in a List
          }

          // Set 'isLoading' to false to indicate loading is complete
          isLoading = false;
        });
      } else {
        setState(() {
          // If status code isn't 200, set an error message with status code
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false; // Set 'isLoading' to false
        });
      }
    } catch (e) {
      // Catch any error during the fetch operation
      setState(() {
        // Set the error message to show the exception
        errorMessage = 'Error: $e';
        isLoading = false; // Set 'isLoading' to false
      });

      // Log the error for debugging
      log('Fetch error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Data"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DataScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : data != null && data!.isNotEmpty
                  ? ListView.builder(
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(data![index].toString()),
                        );
                      },
                    )
                  : const Center(child: Text("No data available")),
    );
  }
}
