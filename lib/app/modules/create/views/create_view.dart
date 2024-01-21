import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this line for date formatting
import '../controllers/create_controller.dart';
import 'package:country_state_city/country_state_city.dart' as csc;

class CreateView extends GetView<CreateController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Contact'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: controller.savePerson,
          ),
        ],
      ),
      body: Form(
          key: controller.formKey,
          child: Obx(
            () => ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                buildTextFormField(
                  label: 'Name',
                  icon: Icons.person,
                  onSaved: (value) => controller.name.value = value ?? '',
                ),
                buildTextFormField(
                  numpad: true,
                  label: 'Mobile Number',
                  icon: Icons.phone,
                  onSaved: (value) =>
                      controller.mobileNumber.value = value ?? '',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a mobile number' : null,
                  defaultValue: controller.mobileNumber.value,
                ),
                buildTextFormField(
                  numpad: true,
                  label: 'WhatsApp Number',
                  icon: Icons.chat,
                  onSaved: (value) =>
                      controller.whatsappNumber.value = value ?? '',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a WhatsApp number' : null,
                  defaultValue: controller.whatsappNumber.value,
                ),
                Obx(
                  () => buildTextButton(
                    icon: Icons.calendar_today,
                    label: controller.dob.value != null
                        ? 'Date of Birth: ${DateFormat('yyyy-MM-dd').format(controller.dob.value!)}'
                        : 'Select Date of Birth',
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: controller.dob.value ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        controller.dob.value = pickedDate;
                      }
                    },
                  ),
                ),
                DropdownButtonFormField<csc.State>(
                  decoration: InputDecoration(
                    labelText: 'State',
                    prefixIcon: Icon(Icons.map),
                    border: OutlineInputBorder(),
                  ),
                  // value: controller.selectedState.value,
                  items: controller.states.map((state) {
                    return DropdownMenuItem<csc.State>(
                      value: state,
                      child: Text(state.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.placeOfBirth.state = value!.name;
                    controller.selectedState.value = value.isoCode;
                  },
                ),
                DropdownButtonFormField<csc.City>(
                  decoration: const InputDecoration(
                    labelText: 'City',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                  // value: controller.selectedCity.value,
                  items: controller.cities.map((city) {
                    return DropdownMenuItem<csc.City>(
                      value: city,
                      child: Text(city.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.placeOfBirth.city = value!.name;
                  },
                ),
                buildTextFormField(
                  label: 'District',
                  icon: Icons.location_city,
                  onSaved: (value) => controller.placeOfBirth.district = value,
                ),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Series Number',
                    prefixIcon: Icon(Icons.confirmation_number),
                    border: OutlineInputBorder(),
                  ),
                  // value: controller.seriesNumber,
                  items: [1, 2, 3, 4, 5].map((number) {
                    return DropdownMenuItem<int>(
                      value: number,
                      child: Text(number.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.seriesNumber = value ?? 0;
                  },
                ),

                // ... other fields ...
              ],
            ),
          )),
    );
  }

  TextFormField buildTextFormField({
    required String label,
    required IconData icon,
    required Function(String?) onSaved,
    String? Function(String?)? validator,
    bool numpad = false,
    String? defaultValue,
  }) {
    return TextFormField(
      initialValue: defaultValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(), // Add border to input field
      ),
      onSaved: onSaved,
      validator: validator,
      keyboardType: numpad ? TextInputType.number : TextInputType.text,
    );
  }
}

Widget buildTextButton({
  required String label,
  required VoidCallback onPressed,
  required IconData icon,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 8.0),
    // margin: EdgeInsets.only(bottom: 16.0), // Add margin for spacing
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black54), // Add border
      borderRadius: BorderRadius.circular(5), // Add rounded corners
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.black54),
        TextButton(
          onPressed: onPressed,
          child: // Add i// Add spacing
              Text(
            label,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          style: TextButton.styleFrom(
            // padding: EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            // backgroundColor: Colors.grey[200], // Add background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Add rounded corners
            ),
          ),
        ),
      ],
    ),
  );
}
