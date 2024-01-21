import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internal/app/data/people.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxList<Person> people = <Person>[
    // Person(
    //   name: 'Ishan Doe',
    //   mobileNumber: '1234567890',
    //   whatsappNumber: '1234567890',
    //   dob: DateTime.now(),
    //   placeOfBirth: PlaceOfBirth(
    //     district: 'District',
    //     city: 'City',
    //     state: 'State',
    //     country: 'Country',
    //   ),
    //   seriesNumber: 1,
    // ),
    // Person(
    //   name: 'Yashu Doe',
    //   mobileNumber: '1234567890',
    //   whatsappNumber: '1234567890',
    //   dob: DateTime.now(),
    //   placeOfBirth: PlaceOfBirth(
    //     district: 'District',
    //     city: 'City',
    //     state: 'State',
    //     country: 'Country',
    //   ),
    //   seriesNumber: 2,
    // ),
    // Person(
    //   name: 'John Smith',
    //   mobileNumber: '1234567890',
    //   whatsappNumber: '1234567890',
    //   dob: DateTime.now(),
    //   placeOfBirth: PlaceOfBirth(
    //     district: 'District',
    //     city: 'City',
    //     state: 'State',
    //     country: 'Country',
    //   ),
    //   seriesNumber: 3,
    // ),
    // Person(
    //   name: 'Jane Smith',
    //   mobileNumber: '1234567890',
    //   whatsappNumber: '1234567890',
    //   dob: DateTime.now(),
    //   placeOfBirth: PlaceOfBirth(
    //     district: 'District',
    //     city: 'City',
    //     state: 'State',
    //     country: 'Country',
    //   ),
    //   seriesNumber: 4,
    // ),
  ].obs;
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
      Uri.parse('https://horoscope-backend.vercel.app/api/person'),
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
