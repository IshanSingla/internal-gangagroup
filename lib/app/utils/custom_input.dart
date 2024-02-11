import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:internal/app/data/people.dart';
import 'package:intl/intl.dart';

String? validateIndianMobileNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Mobile number is required';
  }

  // Regex for validating Indian mobile number
  String pattern = r'(^[6-9]\d{9}$)';
  RegExp regExp = RegExp(pattern);

  if (!regExp.hasMatch(value)) {
    return 'Enter a valid mobile number';
  }
  return null;
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    // Limit the length of input to 10 characters (dd-mm-yyyy)
    if (text.length > 10) {
      return oldValue;
    }

    // Add dashes after day and month (dd-mm-yyyy)
    if ((text.length == 2 || text.length == 5) &&
        oldValue.text.length < newValue.text.length) {
      text += '-';
    }

    // Split the text into parts
    var parts = text.split('-');
    if (parts.length > 1) {
      // Validate days only if day part is complete (2 digits)
      if (parts[0].length == 2) {
        int? days = int.tryParse(parts[0]);
        if (days != null && (days < 1 || days > 31)) {
          return oldValue; // Reject input
        }
      }
      // Validate months only if month part is complete (2 digits)
      if (parts.length > 1 && parts[1].length == 2) {
        int? months = int.tryParse(parts[1]);
        if (months != null && (months < 1 || months > 12)) {
          return oldValue; // Reject input
        }
      }
      // Validate years only if year part is complete (4 digits)
      if (parts.length > 2 && parts[2].length == 4) {
        int? years = int.tryParse(parts[2]);
        if (years != null && (years > DateTime.now().year)) {
          return oldValue; // Reject input
        }
      }
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    // Limit the length of input to 8 characters (HH:mm:ss)
    if (text.length > 8) {
      return oldValue;
    }

    // Add colons after hour and minute (HH:mm:ss)
    if ((text.length == 2 || text.length == 5) &&
        oldValue.text.length < newValue.text.length) {
      text += ':';
    }

    // Split the text into parts
    var parts = text.split(':');
    if (parts.length > 1) {
      // Validate hours
      int? hours = int.tryParse(parts[0]);
      if (hours != null && (hours < 0 || hours > 23)) {
        return oldValue; // Reject input
      }
      // Validate minutes
      if (parts.length > 1) {
        int? minutes = int.tryParse(parts[1]);
        if (minutes != null && (minutes < 0 || minutes > 59)) {
          return oldValue; // Reject input
        }
      }
      // Validate seconds
      if (parts.length > 2) {
        int? seconds = int.tryParse(parts[2]);
        if (seconds != null && (seconds < 0 || seconds > 59)) {
          return oldValue; // Reject input
        }
      }
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class EditableListTile extends StatefulWidget {
  final Icon leading;
  final String title;
  final String? subtitle;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final Function(String) onChanged;
  final Function()? onTap;

  EditableListTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    required this.onChanged,
    this.onTap,
  });

  @override
  _EditableListTileState createState() => _EditableListTileState();
}

class _EditableListTileState extends State<EditableListTile> {
  bool _isEditingMode = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.subtitle ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: _isEditingMode
          ? _buildSubtitleTextField()
          : Text(widget.subtitle ?? "Not Available"),
      trailing: _buildTrailingButton(),
      leading: widget.leading,
      onTap: widget.onTap,
    );
  }

  Widget _buildSubtitleTextField() {
    return TextField(
      controller: _controller,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      onSubmitted: (value) {
        _toggleEditMode();
        widget.onChanged(_controller.text);
      },
    );
  }

  Widget _buildTrailingButton() {
    return IconButton(
      icon: Icon(_isEditingMode ? Icons.check : Icons.edit),
      onPressed: _isEditingMode ? _toggleEdit : _toggleEditMode,
    );
  }

  void _toggleEdit() {
    widget.onChanged(_controller.text);
    setState(() {
      _isEditingMode = !_isEditingMode;
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditingMode = !_isEditingMode;
    });
  }
}

class EditableLocationField extends StatefulWidget {
  final String title;
  final PlaceOfBirth? placeOfBirth;
  final Function(PlaceOfBirth?) onChanged;

  EditableLocationField({
    required this.title,
    required this.placeOfBirth,
    required this.onChanged,
  });

  @override
  _EditableLocationFieldState createState() => _EditableLocationFieldState();
}

class _EditableLocationFieldState extends State<EditableLocationField> {
  bool _isEditingMode = false;
  late TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.placeOfBirth?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: _isEditingMode
          ? _buildLocationTextField()
          : Text(widget.placeOfBirth?.description ?? "Not Available"),
      trailing: IconButton(
        icon: Icon(_isEditingMode ? Icons.check : Icons.edit),
        onPressed: _toggleEditMode,
      ),
      leading: Icon(Icons.location_city),
    );
  }

  Widget _buildLocationTextField() {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: _controller, // Bind to the controller
      googleAPIKey: "AIzaSyDQ2c_pOSOFYSjxGMwkFvCVWKjYOM9siow",
      debounceTime: 600,
      countries: const ["in"],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (place) {
        place.description = _controller.text;
        var sa = PlaceOfBirth(
          description: place.description,
          latitude: double.parse(place.lat ?? ""),
          longitude: double.parse(place.lng ?? ""),
        );
        widget.onChanged(sa);
        _toggleEditMode();
      },
      itemClick: (Prediction prediction) {
        _controller.text = prediction.description ?? "";
        _toggleEditMode();
      },
      // getPlaceDetailWithLatLng: controller.handleLocationSelection,
      // itemClick: controller.handleLocationSelection,
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

  

  void _toggleEditMode() {
    setState(() {
      _isEditingMode = !_isEditingMode;
    });
  }
}

class EditableDOBField extends StatefulWidget {
  final String title;
  final DateTime? dob;
  final Function(DateTime) onChanged;

  EditableDOBField({
    required this.title,
    required this.dob,
    required this.onChanged,
  });

  @override
  _EditableDOBFieldState createState() => _EditableDOBFieldState();
}

class _EditableDOBFieldState extends State<EditableDOBField> {
  bool _isEditingMode = false;
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
    if (widget.dob != null) {
      _dateController.text = DateFormat('dd-MM-yyyy').format(widget.dob!);
      _timeController.text = DateFormat('HH:mm:ss').format(widget.dob!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: _isEditingMode
          ? _buildDateTimeFields()
          : Text(widget.dob != null
              ? DateFormat('dd-MM-yyyy HH:mm:ss').format(widget.dob!)
              : "Not Available"),
      trailing: IconButton(
        icon: Icon(_isEditingMode ? Icons.check : Icons.edit),
        onPressed: _isEditingMode ? _toggleEdit : _toggleEditMode,
      ),
      leading: Icon(Icons.calendar_today),
    );
  }

  Widget _buildDateTimeFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _dateController,
            // decoration: InputDecoration(
            //   labelText: 'Date (dd-mm-yyyy)',
            //   border: OutlineInputBorder(),
            //   hintText: 'dd-mm-yyyy',
            //   prefixIcon: Icon(Icons.calendar_today),
            // ),
            keyboardType: TextInputType.datetime,
            inputFormatters: [
              DateInputFormatter(), // Add custom input formatter for date (dd-mm-yyyy),
            ],
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: _timeController,
            keyboardType: TextInputType.datetime,
            // inputFormatters: [
            //   FilteringTextInputFormatter.singleLineFormatter,
            // ],
            inputFormatters: [
              // FilteringTextInputFormatter.digitsOnly,
              TimeInputFormatter(), // Add custom input formatter for time (HH:mm:ss)
            ],
          ),
        ),
      ],
    );
  }

  void _toggleEdit() {
    var date = DateFormat('dd-MM-yyyy HH:mm:ss')
        .parse("${_dateController.text} ${_timeController.text}").toUtc();
    widget.onChanged(date);
    setState(() {
      _isEditingMode = !_isEditingMode;
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditingMode = !_isEditingMode;
    });
  }
}
