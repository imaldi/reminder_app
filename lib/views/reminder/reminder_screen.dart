import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/reminder_bloc.dart';
import '../models/reminder.dart';

class ReminderScreen extends StatefulWidget {
  final Reminder? reminder;
  final int? index;

  ReminderScreen({this.reminder, this.index});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _title = widget.reminder?.title ?? '';
    _description = widget.reminder?.description ?? '';
    _dateTime = widget.reminder?.dateTime ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder == null ? 'Add Reminder' : 'Edit Reminder'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _dateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_dateTime),
                    );
                    if (selectedTime != null) {
                      setState(() {
                        _dateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: Text('Select Date & Time'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final reminder = Reminder(
                      title: _title,
                      description: _description,
                      dateTime: _dateTime,
                    );

                    if (widget.reminder == null) {
                      BlocProvider.of<ReminderBloc>(context).add(AddReminder(reminder));
                    } else {
                      BlocProvider.of<ReminderBloc>(context).add(UpdateReminder(widget.index!, reminder));
                    }

                    Navigator.of(context).pop();
                  }
                },
                child: Text('Save Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
