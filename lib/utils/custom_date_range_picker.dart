

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class CustomDateRangePicker extends StatefulWidget {
  final bool isEndDate;
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomDateRangePicker({
    super.key,
    required this.isEndDate,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  CustomDateRangePickerState createState() => CustomDateRangePickerState();
}

class CustomDateRangePickerState extends State<CustomDateRangePicker> {
  late DateTime selectedDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<String> quickOptions = ['Today', 'Next Monday', 'Next Tuesday', 'After 1 week'];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  void onQuickSelect(String option) {
    setState(() {
      switch (option) {
        case 'Today':
          selectedDate = DateTime.now();
          break;
        case 'Next Monday':
          selectedDate = DateTime.now().add(Duration(days: (8 - DateTime.now().weekday) % 7));
          break;
        case 'Next Tuesday':
          selectedDate = DateTime.now().add(Duration(days: (9 - DateTime.now().weekday) % 7));
          break;
        case 'After 1 week':
          selectedDate = DateTime.now().add(Duration(days: 7));
          break;
      }
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(78),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3,
                physics: NeverScrollableScrollPhysics(),
                children: quickOptions.map((option) {
                  return TextButton(
                    onPressed: () => onQuickSelect(option),
                    child: Text(option),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              TableCalendar(
                focusedDay: selectedDate,
                firstDay: DateTime(2000),
                lastDay: DateTime(2100),
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    selectedDate = selectedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  titleTextFormatter: (date, locale) =>
                      DateFormat.yMMMM(locale).format(date),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.black),
                  todayTextStyle: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(width: 8.0),
                      Text(formatDate(selectedDate)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          backgroundColor: Colors.blue[50],
                          shadowColor: Colors.blue.withAlpha(77),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          widget.onDateSelected(selectedDate);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatDate(DateTime date) {
  final now = DateTime.now();
  if (date.year == now.year && date.month == now.month && date.day == now.day) {
    return 'Today';
  }
  return '${date.day} ${_getMonthName(date.month)}, ${date.year}';
}

String _getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[month - 1];
}
