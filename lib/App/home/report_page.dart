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
        body: Column(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
                visible: _image != null,
                child: Text(
                  'Review',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: _image == null
                  ? ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Take The Photo',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    )
                  : Image.file(File(_image!.path), fit: BoxFit.cover),
            ),
            Visibility(
              visible: _image != null,
              child: ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Description',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade300,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        width: 0.7,
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        width: 0.7,
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ),
                maxLines: 4,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
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
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
