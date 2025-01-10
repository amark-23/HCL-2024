import 'package:flutter/material.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _startingLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _maxParticipants = 1;

  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  void _showDescriptionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter event description...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      appBar: AppBar(
        backgroundColor: Colors.indigo[400],
        title: const Text('Creating Event',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Event Name',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.indigo[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Starting Location',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _startingLocationController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.indigo[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'End Location',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _endLocationController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.indigo[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Max Participants',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (_maxParticipants > 1) {
                                  _maxParticipants--;
                                }
                              });
                            },
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.white),
                          ),
                          Text(
                            '$_maxParticipants',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _maxParticipants++;
                              });
                            },
                            icon: const Icon(Icons.add_circle,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date & Time',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () => _pickDateTime(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.indigo[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _selectedDate != null && _selectedTime != null
                                ? _selectedTime!.format(context)
                                : 'Select Date & Time',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Add Description',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: _showDescriptionModal,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.indigo[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _descriptionController.text.isNotEmpty
                      ? _descriptionController.text
                      : 'Add Description...',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      // Handle event creation logic
                    },
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
