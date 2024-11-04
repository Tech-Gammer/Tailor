import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ClientProvider with ChangeNotifier {
  final DatabaseReference _clientRef = FirebaseDatabase.instance.ref().child('clients');

  Map<String, Map<String, dynamic>> _clients = {};

  Map<String, Map<String, dynamic>> get clients => _clients;




  // Generate a serial number based on the current timestamp
  String generateSerialNo() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> addClient({
    required String serialNo,
    required String name,
    required String mobileNo,
    required String address,
  }) async {
    // Create a client map
    Map<String, dynamic> clientData = {
      'serialNo': serialNo,
      'name': name,
      'mobileNo': mobileNo,
      'address': address,
    };

    // Save data in Firebase Realtime Database
    await _clientRef.child(serialNo).set(clientData);

    notifyListeners();
  }


// Fetch clients from Firebase
  Future<void> fetchClients() async {
    final snapshot = await _clientRef.get();
    if (snapshot.exists) {
      _clients = (snapshot.value as Map<dynamic, dynamic>).map(
            (key, value) => MapEntry(
          key as String,
          Map<String, dynamic>.from(value as Map),
        ),
      );
      notifyListeners();
    } else {
      _clients = {};
      notifyListeners();
    }
  }



  // Method to update client details
  Future<void> updateClient({
    required String serialNo,
    required String name,
    required String mobileNo,
    required String address,
  }) async {
    Map<String, dynamic> clientData = {
      'serialNo': serialNo,
      'name': name,
      'mobileNo': mobileNo,
      'address': address,
    };
    await _clientRef.child(serialNo).update(clientData);
    await fetchClients(); // Refresh client list
  }

  // Delete a client and refresh the list
  Future<void> deleteClient(String serialNo) async {
    await _clientRef.child(serialNo).remove();
    await fetchClients(); // Ensure the client list is updated
  }

}
