import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internal/app/data/people.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:http/http.dart' as http;
import 'package:internal/app/modules/home/controllers/home_controller.dart';

class CreateController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var arguments = Get.arguments;
  HomeController homeController = Get.find();

  RxString name = "".obs, mobileNumber = "".obs, whatsappNumber = "".obs;
  RxList<csc.State> states = <csc.State>[].obs;
  RxList<csc.City> cities = <csc.City>[].obs;
  Rx<String> selectedState = "".obs;
  PlaceOfBirth placeOfBirth = PlaceOfBirth();
  int seriesNumber = 1;
  Rx<DateTime?> dob = Rx<DateTime?>(null);
  String? genderValue;
  RxList gender = ["Male", "Female"].obs;
  @override
  void onInit() {
    super.onInit();
    if (arguments != null) {
      debugPrint(arguments['number']);
      mobileNumber.value = arguments['number'];
      whatsappNumber.value = arguments['number'];
    }
    csc.getStatesOfCountry("IN").then((value) {
      states.value = value;
    });
    // when change in placeOfBirth call a function to fetch cities
    ever(selectedState, (_) {
      csc.getStateCities("IN", selectedState.value).then((value) {
        cities.value = value;
      });
    });
  }

  void savePerson() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Person newPerson = Person(
        name: name.value,
        mobileNumber: mobileNumber.value,
        whatsappNumber: whatsappNumber.value,
        dob: dob.value,
        placeOfBirth: placeOfBirth,
        seriesNumber: seriesNumber,
      );
      debugPrint(newPerson.toJson().toString());
      http
          .post(
        Uri.parse('https://horoscope-backend.vercel.app/api/person'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newPerson.toJson()),
      )
          .then((value) {
        if (value.statusCode > 320) {
          Get.snackbar("Error", "Something went wrong");
          debugPrint(value.body);
          return;
        }
        debugPrint(value.body);
        homeController.refresha();
        Get.back();
        Get.snackbar("Success", "Contact created successfully");
      }).catchError((e) {
        Get.snackbar("Error", "Something went wrong");
        debugPrint(e.toString());
      });
    }
  }

  void fetchCities(String state) {
    // TODO: Fetch cities for the selected state from an API
    // Update cities list and selectedCity
    update();
  }
}
