import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:internal/app/utils/status.dart';
import '../../../utils/custom_input.dart';
import '../controllers/create_controller.dart';

class CreateView extends GetView<CreateController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Contact'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: controller.savePerson,
          ),
        ],
      ),
      body: Form(
          key: controller.formKey,
          child: Obx(
            () => ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                buildTextFormField(
                  controler: controller.nameController,
                  label: 'Name',
                  icon: Icons.person,
                  // onSaved: (value) => controller.name.value = value ?? '',
                ),
                const SizedBox(height: 15),
                buildTextFormField(
                  controler: controller.mobileNumberController,
                  numpad: true,
                  label: 'Mobile Number',
                  icon: Icons.phone,
                  // onSaved: (value) =>
                  //     controller.mobileNumber.value = value ?? '',
                  validator:
                      validateIndianMobileNumber, // Use the validator here
                  // defaultValue: controller.mobileNumber.value,
                ),
                const SizedBox(height: 15),
                buildToggleWhatsAppField(),
                controller.showWhatsAppField.value
                    ? buildWhatsAppNumberField()
                    : Container(),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                        child: buildDateFormField(controller.dateController)),
                    const SizedBox(width: 10), // Add spacing between fields
                    Expanded(
                        child: buildTimeFormField(
                            context, controller.timeController)),
                  ],
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                  value: controller.genderValue,
                  items: <DropdownMenuItem>[
                    const DropdownMenuItem<String>(
                      child: Text("Gender"),
                    ),
                    ...controller.gender.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    controller.genderValue = value;
                  },
                ),
                const SizedBox(height: 15),
                buildLocationField(controller),
                const SizedBox(height: 15),
                buildStatusDropdown(),
                // ... other fields ...
              ],
            ),
          )),
    );
  }

  Widget buildToggleWhatsAppField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Show WhatsApp Number:'),
        Switch(
          value: controller.showWhatsAppField.value,
          onChanged: (value) {
            controller.showWhatsAppField.value = value;
          },
        ),
      ],
    );
  }

  Widget buildWhatsAppNumberField() {
    return buildTextFormField(
      controler: controller.whatsappNumberController,
      numpad: true,
      label: 'WhatsApp Number',
      icon: Icons.chat,
      // onSaved: (value) => controller.whatsappNumber.value = value ?? '',
      validator: validateIndianMobileNumber, // Use the validator here
      // defaultValue: controller.whatsappNumber.value,
    );
  }

  TextFormField buildTextFormField({
    required String label,
    required IconData icon,
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    bool numpad = false,
    String? defaultValue,
    required TextEditingController controler,
  }) {
    return TextFormField(
      controller: controler,
      initialValue: defaultValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(), // Add border to input field
      ),
      onSaved: onSaved,
      validator: validator,
      keyboardType: numpad ? TextInputType.number : TextInputType.text,
    );
  }

  TextFormField buildDateFormField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Date of Birth (dd-mm-yyyy)',
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
        hintText: 'dd-mm-yyyy',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        // FilteringTextInputFormatter.digitsOnly,
        DateInputFormatter(), // Add custom input formatter for date (dd-mm-yyyy),
      ],
    );
  }

  Widget buildTimeFormField(
      BuildContext context, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Time (HH:mm:ss)',
        prefixIcon: Icon(Icons.access_time),
        border: OutlineInputBorder(),
        hintText: 'HH:mm:ss',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        // FilteringTextInputFormatter.digitsOnly,
        TimeInputFormatter(), // Add custom input formatter for time (HH:mm:ss)
      ],
    );
  }

  Widget buildLocationField(CreateController controller) {
    return GooglePlaceAutoCompleteTextField(
      textEditingController:
          controller.locationController, // Bind to the controller
      googleAPIKey: "AIzaSyDQ2c_pOSOFYSjxGMwkFvCVWKjYOM9siow",
      inputDecoration: const InputDecoration(
        labelText: 'Location',
        prefixIcon: Icon(Icons.location_on),
        // border: OutlineInputBorder(),
      ),
      debounceTime: 600,
      countries: const ["in"],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: controller.handleLocationSelection,
      itemClick: controller.handleLocationSelection,
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 5),
              Expanded(child: Text(prediction.description ?? ""))
            ],
          ),
        );
      },

      isCrossBtnShown: true,
      containerHorizontalPadding: 5,
    );
  }

  Widget buildTextButton({
    required String label,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 8.0),
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
            style: TextButton.styleFrom(
              // padding: EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              // backgroundColor: Colors.grey[200], // Add background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Add rounded corners
              ),
            ),
            child: // Add i// Add spacing
                Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
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
      value: controller
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
        controller.seriesNumber = value ?? 0;
      },
    );
  }
}
