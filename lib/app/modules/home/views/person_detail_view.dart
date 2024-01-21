import 'package:flutter/material.dart';
import 'package:internal/app/data/people.dart';

class PersonDetailPage extends StatelessWidget {
  final Person person;

  PersonDetailPage({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(person.name ?? 'No Name'),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 350.0,
            floating: false,
            // pinned: true,
            title: Text(person.name ?? 'No Name'),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 90,
                  child: Text(
                    person.name == "" || person.name == null
                        ? person.mobileNumber.substring(0, 1)
                        : person.name!.substring(0, 1),
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: const Color.fromARGB(255, 125, 197, 255),
                ),
                SizedBox(height: 10),
                Text(
                  person.name == "" || person.name == null
                      ? 'No Name'
                      : person.name!,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
            // padding: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(horizontal: 15),

            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              // color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Contact Info',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
          )),
        ],
      ),
    );
  }
}
