import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/clientprovider.dart';
import 'total_clients.dart';

class AddClient extends StatefulWidget {
  final String? serialNo;
  final String? name;
  final String? mobileNo;
  final String? address;

  const AddClient({
    Key? key,
    this.serialNo,
    this.name,
    this.mobileNo,
    this.address,
  }) : super(key: key);

  @override
  State<AddClient> createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _addressController = TextEditingController();

  late String _serialNo;

  @override
  void initState() {
    super.initState();
    final clientProvider = Provider.of<ClientProvider>(context, listen: false);

    // If editing, populate the fields; else generate new serial number
    if (widget.serialNo != null) {
      _serialNo = widget.serialNo!;
      _nameController.text = widget.name ?? '';
      _mobileNoController.text = widget.mobileNo ?? '';
      _addressController.text = widget.address ?? '';
    } else {
      _serialNo = clientProvider.generateSerialNo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ClientListPage()),
          );
        }, icon: const Icon(Icons.arrow_back)),
        title: const Text('Add Client'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter Client Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Display the generated serial number
                  Text(
                    'Serial Number: $_serialNo',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _mobileNoController,
                    label: 'Mobile No',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Address',
                    icon: Icons.location_on,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await Provider.of<ClientProvider>(context, listen: false).addClient(
                          serialNo: _serialNo,
                          name: _nameController.text,
                          mobileNo: _mobileNoController.text,
                          address: _addressController.text,
                        );

                        // Clear form fields and generate a new serial number
                        _nameController.clear();
                        _mobileNoController.clear();
                        _addressController.clear();
                        setState(() {
                          _serialNo = Provider.of<ClientProvider>(context, listen: false).generateSerialNo();
                        });

                        // Show a success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Client added successfully!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.blueAccent.withOpacity(0.5),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Save Client',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.blueAccent.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileNoController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
