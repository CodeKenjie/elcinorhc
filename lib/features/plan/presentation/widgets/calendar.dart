import 'package:flutter/material.dart';
import '../controller/plan_controller.dart';
import 'plan_form_dialog.dart';

class Calendar extends StatefulWidget{
  final PlanController controller;
  final ValueChanged<DateTime>? onDateSelected;

  const Calendar({
    super.key, 
    required this.controller,
    this.onDateSelected
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final List<String> weekdays = [ 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' ];
  final List<Color> planColors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.greenAccent,
    Colors.deepPurpleAccent,
    Colors.deepOrangeAccent
  ];
  DateTime focusedMonth = DateTime.now();

  DateTime? selectedDate;

  bool _isPastDate(DateTime date) {
    final today = DateTime.now();

    final todayOnly = DateTime(today.year, today.month, today.day);

    final dateOnly = DateTime(date.year, date.month, date.day);

    return dateOnly.isBefore(todayOnly);
  }

  List<DateTime> generateDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);

    final startingWeekday = firstDay.weekday % 7;

    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    final days = <DateTime>[];

    for(int i = 0; i < startingWeekday; i++) {
      days.add(
        firstDay.subtract(Duration(days: startingWeekday - i))
      );
    }

    for(int i = 1; i <= daysInMonth; i++) {
      days.add(
        DateTime(month.year, month.month, i)
      );
    }

    return days;
  }

  void _previousMonth() {
    setState(() {
      focusedMonth = DateTime(focusedMonth.year, focusedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      focusedMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 1);
    });
  }

  String _monthName(int month) {
    final List<String> months = [ 'January', 'February', 'March', 'April', 'May', 'Jun', 'July', 'August', 'September', 'October', 'November', 'December' ];
    return months[month - 1];
  }

  int _planCountForDate(DateTime date) {
    return widget.controller.plans.where((plan){
      return plan.dueAt.year == date.year && plan.dueAt.month == date.month && plan.dueAt.day == date.day;
    }).length;
  }
  @override
  Widget build(BuildContext context){
    final calendarDays = generateDays(focusedMonth);

    return Column(
      children: [
        Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _previousMonth, 
              icon: const Icon(Icons.chevron_left)
            ),
            Text (
              '${_monthName(focusedMonth.month)} ${focusedMonth.year}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            IconButton(
              onPressed: _nextMonth, 
              icon: const Icon(Icons.chevron_right)
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekdays.map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day, 
                  style: TextStyle(
                    fontSize: 14, 
                    color: Colors.grey
                  ),
                )
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 5),
        AnimatedBuilder(
          animation: widget.controller, 
          builder: ((context, child) {
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7), 
            itemCount: calendarDays.length,
            itemBuilder: (context, index) {
              final date = calendarDays[index];
              final today = DateTime.now();

              final isToday = date.year == today.year && date.month == today.month && date.day == today.day;

              final isCurrentMonth = date.month == focusedMonth.month && date.year == focusedMonth.year;

              final isSelected = selectedDate != null && date.year == selectedDate!.year && date.month == selectedDate!.month && date.day == selectedDate!.day;

              final planCount = _planCountForDate(date);

              final isPast = _isPastDate(date);

              return GestureDetector(
                onTap: isPast ? null : (){
                  setState(() {
                    selectedDate = date;
                  });

                  widget.onDateSelected?.call(date);
                },
                onLongPress: isPast ? null : () {
                  showDialog(
                    context: context, 
                    builder: (context) => PlanFormDialog(controller: widget.controller, dueAt: date)
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: isToday ? Colors.black : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(10),
                    color: isSelected ? Colors.deepPurpleAccent : isPast ? Colors.grey.shade100 : Colors.white
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${date.day}', 
                        style: TextStyle(
                          color: isSelected ? Colors.white : isPast ? Colors.grey.shade400 : isCurrentMonth ? Colors.black : Colors.grey
                        ),
                      ),
                      if(planCount > 0)...[
                        Column(
                          children: List.generate(
                            _planCountForDate(date), 
                            (index) {
                              return Container(
                                width: double.infinity,
                                height: 3,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  color: planColors[index % planColors.length],
                                  borderRadius: BorderRadius.circular(2)
                                ),
                              );
                            }
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              );
            }
          );  
        })
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}