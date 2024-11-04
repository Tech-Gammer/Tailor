import 'package:flutter/material.dart';

import '../managerdashboard.dart';

class AddShalwarKameez extends StatefulWidget {
  const AddShalwarKameez({super.key});

  @override
  State<AddShalwarKameez> createState() => _AddShalwarKameezState();
}

class _AddShalwarKameezState extends State<AddShalwarKameez> {
  String? selectedOption;
  List<String> shalwaarMeasurements = ['شلوار لمبائی', 'شلوار پاؤنچہ', 'شلوار گھیرا'];
  List<String> trouserMeasurements = ['ٹراؤزر لمبائی', 'ٹراؤزر پاؤنچہ', 'ٹراؤزر گھیرا'];
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Set RTL for Urdu writing
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const dashBoard()),
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('شلوار قمیض / پتلون فارم'),
          backgroundColor: Colors.blueAccent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      "قمیض",
                      style: TextStyle(
                        fontFamily: 'JameelNoori',
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Table on the right side
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Table(
                            border: TableBorder.all(width: 1.0, color: Colors.black),
                            columnWidths: const {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(3),
                              2: FlexColumnWidth(2),
                            },
                            children: [
                              // Header Row
                              const TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'نام',
                                      style: TextStyle(
                                        fontFamily: 'JameelNoori',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),//////////
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'پیمائش جسم',
                                      style: TextStyle(
                                        fontFamily: 'JameelNoori',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'پیمائش قمیض',
                                      style: TextStyle(
                                        fontFamily: 'JameelNoori',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              // Table rows with TextField
                              _buildTableRow('لمبائی'),
                              _buildTableRow('چھاتی'),
                              _buildTableRow('کمر'),
                              _buildTableRow('دامن'),
                              _buildTableRow('بازو'),
                              _buildTableRow('تیرا'),
                              _buildTableRow('گلا'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Note section on the left side
                    const Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            maxLines: 20,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'یہاں اضافی نوٹس درج کریں',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Dropdown for Shalwaar/Trouser selection
                DropdownButton<String>(
                  hint: const Text('چُنیں'), // "Select" in Urdu
                  value: selectedOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue;
                    });
                  },
                  items: <String>['Shalwaar', 'Trouser'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // Show measurement fields based on selection
                    if (selectedOption != null) ...[
                      Expanded(
                        child: Table(
                          border: TableBorder.all(width: 1.0, color: Colors.black),
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(3),
                            // 2: FlexColumnWidth(2),
                          },
                          children: [
                            // Header Row
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'نام', // "Name" in Urdu
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'پیمائش', // "Body Measurement" in Urdu
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            // Measurement rows based on selection
                            ...(selectedOption == 'Shalwaar'
                                ? shalwaarMeasurements
                                : trouserMeasurements).map((measurement) {
                              return _buildTableRowFor(measurement);
                            }).toList(),
                          ],
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              maxLines: 10,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'یہاں اضافی نوٹس درج کریں',
                              ),
                            ),
                          ],
                        ),
                      ),
          
                    ],
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  TableRow _buildTableRowFor(String label) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'پیمائش درج کریں', // "Enter measurement" in Urdu
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: TextField(
        //     decoration: const InputDecoration(
        //       border: OutlineInputBorder(),
        //       hintText: 'پیمائش درج کریں', // "Enter measurement" in Urdu
        //     ),
        //   ),
        // ),
      ],
    );
  }

  TableRow _buildTableRow(String label) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'JameelNoori',
              fontSize: 20,
              color: Colors.black,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
