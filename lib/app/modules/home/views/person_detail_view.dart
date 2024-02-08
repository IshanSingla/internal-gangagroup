import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internal/app/data/people.dart';
import 'package:internal/app/modules/home/controllers/home_controller.dart';
import 'package:internal/app/utils/status.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonDetailPage extends StatelessWidget {
  final Person person;
  HomeController homeController = Get.find<HomeController>();

  // ignore: use_key_in_widget_constructors
  PersonDetailPage({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            title: Text((person.name == "" || person.name == null)
                ? 'No Name'
                : person.name ?? ""),
          ),
          SliverToBoxAdapter(
            child: Container(
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
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Contact Info',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(person.mobileNumber),
                      subtitle: const Text('Mobile'),
                      onTap: () => _launchDialer(person.mobileNumber),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone_android),
                      title: Text(person.whatsappNumber),
                      subtitle: const Text('WhatsApp'),
                      onTap: () => _launchWhatsApp(person.whatsappNumber),
                    ),
                    ListTile(
                      leading: const Icon(Icons.cake),
                      title: const Text('Date of Birth'),
                      subtitle: Text(person.dob == null
                          ? "Not Available"
                          : person.dob!.toLocal().toString().split(' ')[0] +
                              "   " +
                              person.dob!
                                  .toLocal()
                                  .toString()
                                  .split(' ')[1]
                                  .split(".")[0]),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_city),
                      title: const Text('Place of Birth'),
                      subtitle: Text([
                        person.placeOfBirth?.description ?? "Not Available",
                      ].where((s) => s.isNotEmpty).join(', ')),
                    ),
                    buildStatusDropdown(),
                    // ListTile(
                    //   leading: const Icon(Icons.confirmation_number),
                    //   title: const Text('Status Number'),
                    //   subtitle: Text(
                    //       "${person.seriesNumber}). ${statuses[person.seriesNumber]}"),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusDropdown() {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Status',
        // prefixIcon: Icon(Icons.confirmation_number),
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
        homeController.updateStatus(person);
      },
    );
  }

  void _launchDialer(String number) async {
    final url = 'tel:$number';
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      Get.snackbar("Error", "Could not Open Dialer");
    }
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  void _launchWhatsApp(String number) async {
    // Country code is needed for WhatsApp
    final countryCode = '+91'; // Replace with the appropriate country code

    final url =
        'https://wa.me/$countryCode$number?text='; // You can pre-fill text if you want
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      Get.snackbar("Error", "Could not Open WhatsApp");
    }
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }
}
