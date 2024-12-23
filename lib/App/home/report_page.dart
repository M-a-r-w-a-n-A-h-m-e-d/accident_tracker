import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../main/navigation_bar.dart';
import 'dart:io';

class ReportAccident extends StatefulWidget {
  const ReportAccident({super.key});

  @override
  _ReportAccidentState createState() => _ReportAccidentState();
}

class _ReportAccidentState extends State<ReportAccident> {
  XFile? _image;
  final _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = pickedFile;
      });
    } catch (e) {
      print(e);
    }
  }

  void _showEmptyFieldsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: const Center(
            child: Text(
              'Fill the Fields',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool value) async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(myIndex: 1),
          ),
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSecondary),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(myIndex: 1),
                ),
              );
            },
          ),
          title: Text(
            'Report An Accident',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: _image == null
                    ? ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 110, vertical: 17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: const Text(
                          'Upload Image',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )
                    : Image.file(File(_image!.path), fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: const OutlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
                  maxLines: 4,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
              ),
              const SizedBox(height: 20),
              _image != null
                  ? ElevatedButton(
                      onPressed: () {
                        if (_descriptionController.text.isEmpty) {
                          _showEmptyFieldsDialog();
                          return;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 110, vertical: 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Send Report',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )
                  : const SizedBox(height: 10),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
