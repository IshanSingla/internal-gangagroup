import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:internal/app/data/people.dart';
import 'package:http/http.dart' as http;
import 'package:internal/app/modules/home/controllers/home_controller.dart';
import 'package:internal/app/modules/home/views/person_detail_view.dart';
import 'package:intl/intl.dart';

class CreateController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var arguments = Get.arguments;
  HomeController homeController = Get.find();
  // Add controllers for date, time, and location
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController whatsappNumberController =
      TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  // Variable to track if the WhatsApp number field should be shown
  var showWhatsAppField = false.obs;

  PlaceOfBirth placeOfBirth = PlaceOfBirth();
  int seriesNumber = 0;
  Rx<DateTime?> dob = Rx<DateTime?>(null);
  String? genderValue;
  RxList gender = ["Male", "Female"].obs;
  @override
  void onInit() {
    super.onInit();
    if (arguments != null) {
      debugPrint(arguments['number']);
      mobileNumberController.text = arguments['number'];
      whatsappNumberController.text = arguments['number'];
    }
    http.get(
      Uri.parse('https://horoscope-backend.vercel.app/api/call/ivr'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((value) {
      if (value.statusCode > 320) {
        Get.snackbar("Error", "Something went wrong");
        debugPrint(value.body);
        return;
      }
      try {
        Person person = Person.fromJson(jsonDecode(value.body));
        Get.back();
        Get.to(() => PersonDetailPage(person: person));
      } catch (e) {
        mobileNumberController.text = jsonDecode(value.body)["from"];
      }
    }).catchError((e) {
      Get.snackbar("Error", "Something went wrong");
      debugPrint(e.toString());
    });
  }

  void savePerson() {
    if (!formKey.currentState!.validate()) {
      return; // If validation fails, exit the function early.
    }

    formKey.currentState!.save();

    // Construct the date and time string.
    var data = constructDateTimeString(
      dateController.text,
      timeController.text,
    );
    debugPrint(data);

    // Parse the date and time in the Indian time zone.
    final date = parseDateInLocalTimeZone(data);

    // Create a new person object.
    Person newPerson = constructPerson(date);

    // Post the data to the server.
    postPersonData(newPerson);
  }

  String constructDateTimeString(String dateText, String timeText) {
    var update = timeText.split(":").length == 2
        ? "$timeText:00"
        : timeText.split(":").length == 1
            ? "$timeText:00:00"
            : timeText;
    return "${dateText == "" ? "01-01-1901" : dateText} ${timeText == "" ? "08:00:01" : update}";
  }

  DateTime parseDateInLocalTimeZone(String data) {
    final dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
    // Parse the input date string in the user's local time zone
    DateTime parsedDateTimeLocal = dateFormat.parse(data);
    // Convert the parsed date-time to UTC
    DateTime utcDateTime = parsedDateTimeLocal.toUtc();
    return utcDateTime;
  }

  Person constructPerson(DateTime date) {
    return Person(
      name: nameController.text.isEmpty ? null : nameController.text,
      mobileNumber: mobileNumberController.text,
      whatsappNumber: whatsappNumberController.text.isEmpty
          ? mobileNumberController.text
          : whatsappNumberController.text,
      dob: date,
      placeOfBirth: placeOfBirth,
      seriesNumber: seriesNumber,
      gender: genderValue,
    );
  }

  void postPersonData(Person person) {
    http
        .post(
      Uri.parse('https://horoscope-backend.vercel.app/api/contact'),
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
      Person newPerson = Person.fromJson(
          jsonDecode(response.body)["contact"] as Map<String, dynamic>);
      homeController.refresha();
      Get.back();
      Get.to(() => PersonDetailPage(person: newPerson));
      Get.snackbar("Success", "Contact created successfully");
    }).catchError((error) {
      Get.snackbar("Error", "Something went wrong");
      debugPrint(error.toString());
    });
  }

  void handleLocationSelection(Prediction prediction) {
    placeOfBirth.description = prediction.description;
    locationController.text = prediction.description!;
    refresh();
  }

  void getPlaceDetailWithLatLng(Prediction prediction) {
    debugPrint(
        "Selected location: ${prediction.description} ${prediction.lat} ${prediction.lng}");
    placeOfBirth.description = prediction.description;
    placeOfBirth.latitude = double.parse(prediction.lat ?? "");
    placeOfBirth.longitude = double.parse(prediction.lng ?? "");
    locationController.text = prediction.description!;
    refresh();
  }
}
