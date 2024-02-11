// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internal/app/data/people.dart';
import 'package:internal/app/modules/home/controllers/home_controller.dart';
import 'package:internal/app/utils/custom_input.dart';
import 'package:internal/app/utils/status.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class PersonDetailPage extends StatefulWidget {
  final Person person;
  HomeController homeController = Get.find<HomeController>();

  // ignore: use_key_in_widget_constructors
  PersonDetailPage({required this.person});

  @override
  _PersonDetailPageState createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends State<PersonDetailPage> {
  @override
  Widget build(BuildContext context) {
    Person person = widget.person;
    HomeController homeController = widget.homeController;
    var createdAt = person.createdAt == null
        ? "Not Available"
        : DateFormat("dd-MM-yyyy HH:mm:ss").format(person.createdAt!.toLocal());

    return Scaffold(
      appBar: AppBar(
        title: Text((person.name == "" || person.name == null)
            ? 'No Name'
            : person.name ?? ""),
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromRGBO(247, 248, 250, 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text(
                  'Contact Info',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  createdAt,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              EditableListTile(
                leading: const Icon(Icons.person),
                subtitle: person.name,
                title: 'Name',
                onChanged: (str) {
                  setState(() {
                    person.name = str;
                  });
                  homeController.updates(person);
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Mobile Number'),
                subtitle: Text(person.mobileNumber),
                // onChanged: (str) {},
                onTap: () => _launchDialer(person.mobileNumber),
              ),
              EditableListTile(
                leading: const Icon(Icons.phone_android),
                title: 'WhatsApp',
                subtitle: person.whatsappNumber,
                onChanged: (str) {
                  setState(() {
                    person.whatsappNumber = str;
                  });
                  homeController.updates(person);
                },
                onTap: () => _launchWhatsApp(person.whatsappNumber),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              EditableDOBField(
                title: 'Date of Birth',
                dob: person.dob!.toLocal(),
                onChanged: (newDob) {
                  setState(() {
                    person.dob = newDob;
                  });
                  homeController.updates(person);
                  // Handle updated Date of Birth here
                },
              ),
              EditableLocationField(
                title: 'Place of Birth',
                placeOfBirth: person.placeOfBirth,
                onChanged: (place) {
                  setState(() {
                    person.placeOfBirth = place;
                  });
                  homeController.updates(person);

                  // homeController.updatePlaceOfBirth(person);
                },
              ),
              buildStatusDropdown(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatusDropdown() {
    Person person = widget.person;
    HomeController homeController = widget.homeController;
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(),
      ),
      value: person
          .seriesNumber, // Ensure you have statusNumber in your controller
      items: statuses.asMap().entries.map((entry) {
        int idx = entry.key;
        String val = "${entry.key}). ${entry.value}";
        return DropdownMenuItem<int>(
          value: idx,
          child: Text(val),
        );
      }).toList(),
      onChanged: (value) {
        person.seriesNumber = value ?? 0;
        homeController.updates(person);
      },
    );
  }

  void _launchDialer(String number) async {
    final url = 'tel:$number';
    final Uri url0 = Uri.parse(url);
    if (!await launchUrl(url0)) {
      Get.snackbar("Error", "Could not Open Dialer");
    }
  }

  void _launchWhatsApp(String number) async {
    // Country code is needed for WhatsApp
    const countryCode = '+91'; // Replace with the appropriate country code

    final url =
        'https://wa.me/$countryCode$number?text='; // You can pre-fill text if you want
    final Uri url0 = Uri.parse(url);
    if (!await launchUrl(url0)) {
      Get.snackbar("Error", "Could not Open WhatsApp");
    }
  }
}
