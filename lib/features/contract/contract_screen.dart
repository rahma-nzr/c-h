import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContractFormScreen extends StatefulWidget {
  final String businessOwnerName;

  const ContractFormScreen({super.key, required this.businessOwnerName, required String requestId});

  @override
  State<ContractFormScreen> createState() => _ContractFormScreenState();
}

class _ContractFormScreenState extends State<ContractFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _developerNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  bool _agreementChecked = false;
  bool _isSubmitting = false;

  Future<void> _submitContract() async {
    if (_formKey.currentState!.validate() && _agreementChecked) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        await FirebaseFirestore.instance.collection('contracts').add({
          'developerName': _developerNameController.text,
          'businessOwner': widget.businessOwnerName,
          'email': _emailController.text,
          'cardNumber': _cardNumberController.text,
          'salary': _salaryController.text,
          'duration': _durationController.text,
          'createdAt': FieldValue.serverTimestamp(),
          'status': 'completed',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contract saved successfully!'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting contract: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    } else if (!_agreementChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms first'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    _developerNameController.dispose();
    _emailController.dispose();
    _salaryController.dispose();
    _durationController.dispose();
    _cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract Agreement',
        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),)),
        backgroundColor: Color.fromARGB(255, 4, 26, 134),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(height: 30),

              // Business Owner Info (pre-filled)
              _buildInfoRow('Business Owner:', widget.businessOwnerName),
              const SizedBox(height: 20),
              
              // Developer Name Field
              TextFormField(
                controller: _developerNameController,
                decoration: const InputDecoration(
                  labelText: 'Developer Name',
                  border: OutlineInputBorder(),
                  hintText: 'Enter developer name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter developer name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  hintText: 'Enter email address',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email address';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              
              // Salary Field
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(
                  labelText: 'Salary Amount',
                  border: OutlineInputBorder(),
                  hintText: 'Enter salary amount',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter salary amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              
              // Duration Field
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Work Duration',
                  border: OutlineInputBorder(),
                  hintText: 'Enter work duration (days/months)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter work duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              
              // Card Number Field
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card/Account Number',
                  border: OutlineInputBorder(),
                  hintText: 'Enter card or bank account number',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card/account number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              
              // Agreement Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _agreementChecked,
                    onChanged: (value) {
                      setState(() {
                        _agreementChecked = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'I confirm that I have filled in all contract information and agree to the salary and work duration terms',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Submit Button
              Center(
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitContract,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 4, 26, 134),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          minimumSize: const Size(200, 50),
                        ),
                        child: const Text('Submit Contract'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 4, 26, 134),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}