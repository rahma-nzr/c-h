class SignUpData {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  List<String> skills;
  String about;

  SignUpData({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    this.skills = const [],
    this.about = '',
  });
}
