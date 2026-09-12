import 'dart:math';
import 'package:flutter/material.dart';
import '../controller/plan_controller.dart';
import 'plan_form_dialog.dart';

class Calendar extends StatefulWidget {
  final PlanController controller;
  final ValueChanged<DateTime>? onDateSelected;

  const Calendar({
    super.key,
    required this.controller,
    this.onDateSelected,
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final List<String> weekdays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  final List<Color> planColors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.greenAccent,
    Colors.deepPurpleAccent,
    Colors.deepOrangeAccent,
  ];

  late DateTime focusedMonth;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();

    focusedMonth = DateTime(
      today.year,
      today.month,
      1,
    );

    selectedDate = DateTime(
      today.year,
      today.month,
      today.day,
    );
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  bool _isPastDate(DateTime date) {
    final today = _dateOnly(DateTime.now());
    final dateOnly = _dateOnly(date);

    return dateOnly.isBefore(today);
  }

  List<DateTime> generateDays(DateTime month) {
    final firstDay = DateTime(
      month.year,
      month.month,
      1,
    );

    final startingWeekday = firstDay.weekday % 7;

    final daysInMonth = DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;

    final days = <DateTime>[];

    for (int i = 0; i < startingWeekday; i++) {
      days.add(
        firstDay.subtract(
          Duration(days: startingWeekday - i),
        ),
      );
    }

    for (int day = 1; day <= daysInMonth; day++) {
      days.add(
        DateTime(
          month.year,
          month.month,
          day,
        ),
      );
    }

    return days;
  }

  void _previousMonth() {
    setState(() {
      focusedMonth = DateTime(
        focusedMonth.year,
        focusedMonth.month - 1,
        1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      focusedMonth = DateTime(
        focusedMonth.year,
        focusedMonth.month + 1,
        1,
      );
    });
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  int _planCountForDate(DateTime date) {
    return widget.controller.plans.where((plan) {
      return _isSameDate(
        plan.dueAt,
        date,
      );
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final calendarDays = generateDays(focusedMonth);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.secondary
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '${_monthName(focusedMonth.month)} ${focusedMonth.year}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.secondary
          ),
          child: Row(
            children: weekdays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 5),
        AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.secondary
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                ),
                itemCount: calendarDays.length,
                itemBuilder: (context, index) {
                  final date = calendarDays[index];
              
                  final isToday = _isSameDate(
                    date,
                    DateTime.now(),
                  );
              
                  final isCurrentMonth =
                      date.month == focusedMonth.month &&
                      date.year == focusedMonth.year;
              
                  final isSelected = _isSameDate(
                    date,
                    selectedDate,
                  );
              
                  final isPast = _isPastDate(date);
                  final planCount = _planCountForDate(date);
              
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = _dateOnly(date);
                      });
              
                      widget.onDateSelected?.call(
                        _dateOnly(date),
                      );
                    },
                    onLongPress: isPast
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return PlanFormDialog(
                                  controller: widget.controller,
                                  dueAt: _dateOnly(date),
                                );
                              },
                            );
                          },
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isToday
                            ? const Color.fromARGB(255, 76, 175, 142)
                            : isPast
                                ? Color.fromARGB(117, 92, 184, 150)
                                : Theme.of(context).colorScheme.surface,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: isSelected
                            ? const Color.fromARGB(255, 76, 175, 142)
                            : isPast
                                ? Color.fromARGB(117, 92, 184, 150)
                                : Theme.of(context).colorScheme.secondary,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : isPast
                                      ? Theme.of(context)
                                          .colorScheme
                                          .surface
                                      : isCurrentMonth
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                            ),
                          ),
                          if (planCount > 0)
                            Column(
                              children: List.generate(
                                min(planCount, 3),
                                (index) {
                                  return Container(
                                    width: double.infinity,
                                    height: 3,
                                    margin: const EdgeInsets.only(
                                      top: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: planColors[
                                          index % planColors.length],
                                      borderRadius:
                                          BorderRadius.circular(2),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}




