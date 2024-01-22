import 'package:flutter/material.dart';
import 'package:internal/app/data/people.dart';

class PersonDetailPage extends StatelessWidget {
  final Person person;

  // ignore: use_key_in_widget_constructors
  const PersonDetailPage({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            title: Text(person.name ?? 'No Name'),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: const Color.fromRGBO(6, 184, 239, 0.2),
                  child: Text(
                    person.name == "" || person.name == null
                        ? person.mobileNumber.substring(0, 1)
                        : person.name!.substring(0, 1),
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  person.name == "" || person.name == null
                      ? 'No Name'
                      : person.name!,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ],
            ),
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
                      leading: Icon(Icons.phone),
                      title: Text(person.mobileNumber),
                      subtitle: Text('Mobile'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone_android),
                      title: Text(person.whatsappNumber),
                      subtitle: Text('WhatsApp'),
                    ),
                    ListTile(
                      leading: Icon(Icons.cake),
                      title: Text('Date of Birth'),
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
                      leading: Icon(Icons.location_city),
                      title: Text('Place of Birth'),
                      subtitle: Text([
                        person.placeOfBirth?.district,
                        person.placeOfBirth?.city,
                        person.placeOfBirth?.state,
                        person.placeOfBirth?.country,
                      ].where((s) => s != null && s.isNotEmpty).join(', ')),
                    ),
                    ListTile(
                      leading: Icon(Icons.confirmation_number),
                      title: Text('Series Number'),
                      subtitle: Text(person.seriesNumber.toString()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
