import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'contact.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({Key? key}) : super(key: key);

  @override
  ContactListScreenState createState() => ContactListScreenState();
}

class ContactListScreenState extends State<ContactListScreen> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Contact> _contacts = [];

  void _addContact() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _contacts.add(Contact(
            name: _nameController.text, number: _numberController.text));
        _nameController.clear();
        _numberController.clear();
      });
    }
  }

  void _deleteContact(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure for Delete?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.cancel_outlined,
                color: Colors.blue,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _contacts.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.delete,
                color: Colors.blue,
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact List",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  if (RegExp(r'[0-9!@#%^&*(),.?":{}|<>]').hasMatch(value)) {
                    return 'Only allow letters';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(
                  hintText: "Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number';
                  }
                  if (RegExp(r'[^0-9-]').hasMatch(value)) {
                    return 'Only allow number and - ';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addContact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF858E98),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Text("Add"),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () {
                        _deleteContact(index);
                      },
                      child: Card(
                        child: ListTile(
                          leading:  Icon(
                            Icons.person,
                            size: 30,
                          ),
                          title: Text(
                            _contacts[index].name,
                            style: const TextStyle(color: Colors.red),
                          ),
                          subtitle: Text(_contacts[index].number),
                          trailing:  IconButton(
                            icon: const Icon(
                              Icons.call,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // Handle call action
                              print('Call ${_contacts[index].number}');
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}