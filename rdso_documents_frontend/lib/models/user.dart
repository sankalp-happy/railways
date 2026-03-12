class User {
  final String hrmsId;
  final String? email;
  final String? phoneNumber;
  final String userStatus;
  final bool isStaff;

  User({
    required this.hrmsId,
    this.email,
    this.phoneNumber,
    required this.userStatus,
    this.isStaff = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      hrmsId: json['HRMS_ID'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      userStatus: json['user_status'],
      isStaff: json['is_staff'] ?? false,
    );
  }
}
