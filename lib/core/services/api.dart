import 'dart:convert';
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
