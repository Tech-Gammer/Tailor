import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/clientprovider.dart';
import 'addclient.dart';
import '../managerdashboard.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({Key? key}) : super(key: key);

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ClientProvider>(context, listen: false).fetchClients();
  }

  void _editClient(BuildContext context, String serialNo) {
    final clientProvider = Provider.of<ClientProvider>(context, listen: false);
    final client = clientProvider.clients[serialNo]!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddClient(
          serialNo: serialNo,
          name: client['name'],
          mobileNo: client['mobileNo'],
          address: client['address'],
        ),
      ),
    ).then((_) {
      Provider.of<ClientProvider>(context, listen: false).fetchClients();
    });
  }

  void _confirmDelete(BuildContext context, String serialNo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Client'),
          content: const Text('Are you sure you want to delete this client?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await Provider.of<ClientProvider>(context, listen: false).deleteClient(serialNo);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Client deleted successfully!')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientProvider = Provider.of<ClientProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => dashBoard()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Client List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: clientProvider.clients.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: clientProvider.clients.length,
        itemBuilder: (context, index) {
          String serialNo = clientProvider.clients.keys.elementAt(index);
          Map<String, dynamic> client = clientProvider.clients[serialNo]!;

          return ListTile(
            title: Text(client['name']),
            subtitle: Text('Mobile: ${client['mobileNo']} \nAddress: ${client['address']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () => _editClient(context, serialNo),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(context, serialNo),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddClient()),
          ).then((_) {
            Provider.of<ClientProvider>(context, listen: false).fetchClients();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
