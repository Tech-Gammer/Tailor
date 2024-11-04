class AdminModel {
  final String adminId;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String adminNumber;

  AdminModel(this.adminId, this.name, this.email, this.phone, this.password, this.role, this.adminNumber);

  Map<String, dynamic> toMap() {
    return {
      'adminId': adminId,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
      'adminNumber': adminNumber
    };
  }
}


class EmployeeModel {
  final String employeeId;
  final String name;
  final String email;
  final String phone;
  final String role;

  EmployeeModel({
    required this.employeeId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  // Factory constructor to create an EmployeeModel from a map
  factory EmployeeModel.fromMap(Map<dynamic, dynamic> map) {
    return EmployeeModel(
      employeeId: map['employeeId'], // Use the provided id for the employeeId
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      role: map['role'] as String,
    );
  }

  // Method to convert EmployeeModel to a map
  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }
}
