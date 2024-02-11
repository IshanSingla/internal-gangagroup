import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/home_controller.dart';
import 'person_detail_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(controller),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              controller.sortPeople();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refresha(),
        child: Obx(
          () {
            debugPrint(controller.people.length.toString());
            return ListView.builder(
              itemCount: controller.people.length,
              itemBuilder: (context, index) {
                final person = controller.people[index];
                return ListTile(
                  title: Text(person.name == null || person.name == ""
                      ? 'No Name'
                      : person.name!),
                  subtitle: Text(person.mobileNumber),
                  trailing: Text(DateFormat("dd-MM-yyyy HH:mm:ss")
                      .format(person.createdAt!.toLocal())),
                  onTap: () {
                    Get.to(() => PersonDetailPage(person: person));
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/create');
          // Handle the '+' button tap
        },
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final HomeController controller;

  CustomSearchDelegate(this.controller);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var results = controller.searchPeople(query);
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final person = results[index];
        return ListTile(
          title: Text(person.name ?? 'No Name'),
          subtitle: Text(person.mobileNumber),
          onTap: () {
            Get.to(() => PersonDetailPage(person: person));
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show when someone searches for something
    var suggestions =
        query.isEmpty ? controller.people : controller.searchPeople(query);

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final person = suggestions[index];
        return ListTile(
          title: Text(person.name ?? 'No Name'),
          subtitle: Text(person.mobileNumber),
          onTap: () {
            Get.to(() => PersonDetailPage(person: person));
          },
        );
      },
    );
  }
}
