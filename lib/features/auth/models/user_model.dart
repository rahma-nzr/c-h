class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String phoneNo;
  final List<String> skills;
  final String about;
  final String description;
  final String password;
  
  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNo,
    required this.skills,
    required this.about,
    required this.description,
    required this.password,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNo,
    List<String>? skills,
    String? about,
    String? description,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      skills: skills ?? this.skills,
      about: about ?? this.about,
      description: description ?? this.description,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNo': phoneNo,
      'skills': skills,
      'about': about,
      'description': description,
      // Note: Don't store password in Firestore for security
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNo: json['phoneNo'],
      skills: List<String>.from(json['skills'] ?? []),
      about: json['about'] ?? '',
      description: json['description'] ?? 'EN',
      password: json['password'] ?? '', // Only for temporary use
    );
  }
}