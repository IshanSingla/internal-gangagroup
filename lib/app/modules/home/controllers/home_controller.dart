import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internal/app/data/people.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxList<Person> people = <Person>[].obs;
  bool isSortedAscending = true;
  @override
  void onInit() {
    super.onInit();
    refresha();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void refresha() {
    http.get(
      Uri.parse('https://horoscope-backend.vercel.app/api/contact'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((value) {
      people.clear();
      people.addAll((jsonDecode(value.body) as List).map((item) {
        var e = Person.fromJson(item);
        return e;
      }));

      // people.value = data;
    });
  }

  void updateStatus(Person person) {
    http
        .put(
      Uri.parse(
          'https://horoscope-backend.vercel.app/api/contact/${person.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(person.toJson()),
    )
        .then((response) {
      if (response.statusCode > 320) {
        Get.snackbar("Error", response.body);
        debugPrint(response.body);
        return;
      }
      Get.snackbar("Success", "Status updated successfully");
      refresha();
    });
  }

  void sortPeople() {
    if (isSortedAscending) {
      // Sort in descending order if currently sorted in ascending order
      people.sort((a, b) => b.name?.compareTo(a.name ?? '') ?? 0);
    } else {
      // Sort in ascending order if currently sorted in descending order
      people.sort((a, b) => a.name?.compareTo(b.name ?? '') ?? 0);
    }
    isSortedAscending = !isSortedAscending; // Toggle the sorting order flag
    people.refresh(); // Refresh the list to update the UI
  }

  // Method to search people by name or mobile number
  // Method to search people by name or mobile number
  List<Person> searchPeople(String query) {
    if (query.isEmpty) {
      return people.toList(); // Return all people if the query is empty
    }
    return people.where((person) {
      // Search by name or mobile number
      return (person.name?.toLowerCase().contains(query.toLowerCase()) ??
              false) ||
          person.mobileNumber.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
