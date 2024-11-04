import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Models/adminmodel.dart';

class AdminProvider with ChangeNotifier {
  AdminModel? _admin;
  EmployeeModel? _employee;

  AdminModel? get admin => _admin;
  EmployeeModel? get employee => _employee;

  // Function to fetch data from both admin and employee nodes
  Future<void> fetchUserData(String userId) async {
    try {
      // Reference to the admin node
      DatabaseReference adminRef = FirebaseDatabase.instance.ref('admin/$userId');
      DataSnapshot adminSnapshot = await adminRef.get();

      // Check if user exists in the admin node
      if (adminSnapshot.exists) {
        Map<dynamic, dynamic> data = adminSnapshot.value as Map<dynamic, dynamic>;

        _admin = AdminModel(
          userId,
          data['name'] ?? 'Unknown',
          data['email'] ?? 'Unknown',
          data['phone'] ?? 'Unknown',
          data['password'] ?? 'Unknown',
          data['role'] ?? 'Unknown',
          data['adminNumber'] ?? 'Unknown',
        );

        // Clear _employee if found in admin
        _employee = null;
        notifyListeners();
        return;
      }

      // If not found in admin, reference the employee node
      DatabaseReference employeeRef = FirebaseDatabase.instance.ref('employee/$userId');
      DataSnapshot employeeSnapshot = await employeeRef.get();

      // Check if user exists in the employee node
      if (employeeSnapshot.exists) {
        Map<dynamic, dynamic> data = employeeSnapshot.value as Map<dynamic, dynamic>;

        _employee = EmployeeModel(
          employeeId: userId,
          name: data['name'] ?? 'Unknown',
          email: data['email'] ?? 'Unknown',
          phone: data['phone'] ?? 'Unknown',
          role: data['role'] ?? 'Unknown',
        );

        // Clear _admin if found in employee
        _admin = null;
        notifyListeners();
      } else {
        print('User not found in either admin or employee nodes');
      }
    } catch (error) {
      print('Failed to fetch user data: $error');
    }
  }
}
