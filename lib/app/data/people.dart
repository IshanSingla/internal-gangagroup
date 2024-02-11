class Person {
  String? id;
  String? name;
  String mobileNumber;
  String whatsappNumber;
  DateTime? dob;
  DateTime? createdAt;
  PlaceOfBirth? placeOfBirth;
  int seriesNumber;
  String? gender;

  Person(
      {this.id,
      this.name,
      required this.mobileNumber,
      required this.whatsappNumber,
      this.dob,
      this.placeOfBirth,
      this.seriesNumber = 0,
      this.gender,
      this.createdAt});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
        id: json['_id'],
        name: json['name'],
        mobileNumber: json['mobile_number'],
        whatsappNumber: json['whatsapp_number'],
        dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        placeOfBirth: json['place_of_birth'] != null
            ? PlaceOfBirth.fromJson(json['place_of_birth'])
            : null,
        seriesNumber: json['series_number'],
        gender: json['gender']);
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile_number': mobileNumber,
      'whatsapp_number': whatsappNumber,
      'dob': dob.toString(),
      'place_of_birth': placeOfBirth?.toJson(),
      'series_number': seriesNumber,
      'gender': gender,
    };
  }
}

class PlaceOfBirth {
  String? description;
  double? latitude;
  double? longitude;

  PlaceOfBirth({this.description, this.latitude, this.longitude});

  factory PlaceOfBirth.fromJson(Map<String, dynamic> json) {
    return PlaceOfBirth(
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
