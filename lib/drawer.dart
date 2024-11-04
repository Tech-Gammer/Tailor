import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/admin provider.dart';

class Drawerfrontside extends StatelessWidget {
  const Drawerfrontside({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the AdminProvider to fetch user data
    final adminProvider = Provider.of<AdminProvider>(context);

    // Fetch the AdminModel and EmployeeModel from AdminProvider
    final adminModel = adminProvider.admin;
    final employeeModel = adminProvider.employee;

    // Handle loading or null case
    if (adminModel == null && employeeModel == null) {
      return const Center(child: CircularProgressIndicator());
    }

    double screenWidth = MediaQuery.of(context).size.width;

    double getFontSize() {
      if (screenWidth < 400) {
        return 10; // Small screens (phones)
      } else if (screenWidth < 600) {
        return 12; // Small to medium screens (large phones/small tablets)
      } else if (screenWidth < 900) {
        return 14; // Medium screens (tablets)
      } else if (screenWidth < 1200) {
        return 16; // Large screens (small laptops)
      } else {
        return 18; // Extra large screens (desktops)
      }
    }

    double getDrawerSize() {
      if (screenWidth < 400) {
        return screenWidth * 0.75; // For small screens, drawer is 75% of screen width
      } else if (screenWidth < 600) {
        return screenWidth * 0.5; // For medium screens, drawer is 50%
      } else {
        return screenWidth * 0.35; // For larger screens, drawer is 35%
      }
    }

    double fontSize = getFontSize();
    double drawerSize = getDrawerSize();

    // Display role text for admin or employee based on the role value
    String getRoleText(String role) {
      return role == "0" ? "Super Admin" : role == '1' ? 'Silai': 'Katai';
    }

    // Choose to display either admin or employee information
    String roleText;
    String userName;

    if (adminModel != null) {
      roleText = getRoleText(adminModel.role);
      userName = adminModel.name; // Get name from admin
    } else {
      roleText = getRoleText(employeeModel!.role); // Default role for employees
      userName = employeeModel?.name ?? "N/A"; // Get name from employee
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: Drawer(
        width: drawerSize,
        backgroundColor: const Color(0xFFDEE5D4),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Role: $roleText',
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: fontSize,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Name: $userName',
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: fontSize * 0.9,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
