import 'package:flutter/material.dart';
import 'package:elcinorch/features/plan/presentation/widgets/plan_form_dialog.dart';
import 'package:elcinorch/app/dependencies.dart';
import '../widgets/calendar.dart';
import '../widgets/plan_card.dart';
import 'package:elcinorch/features/todo/presentation/widgets/todo_dialog.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  final planController = AppDependencies.planController;
  final todoController = AppDependencies.todoController;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  void _loadPlans() async {
    await planController.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding (
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Calendar(
              controller: planController,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            Text (
              'Plans',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey
              ),
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: planController, 
              builder: ((context, child) {
                final plans = planController.plans.where((plan) {
                  return plan.dueAt.year == selectedDate.year && plan.dueAt.month == selectedDate.month && plan.dueAt.day == selectedDate.day;
                }).toList();

                if (planController.isLoading && plans.isEmpty) {
                  return Center (
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: CircularProgressIndicator()
                    )
                  );
                }

                if (plans.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border(
                        bottom: BorderSide(color: Colors.black)
                      )
                    ),
                    child: Column(
                      children: [
                        Text(
                          'No plans for this date.',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Long press the date, or click the add "+" button to create a plan.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return Expanded(
                  child: ListView.separated(
                    itemCount: plans.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 5);
                    },
                    itemBuilder: ((context, index) {
                      final plan = plans[index];

                      return PlanCard(
                        plan: plan,
                        onChanged: (value) => planController.updateStatus(
                          id: plan.id, 
                          completed: value
                        ),
                        onEdit: (context) {
                          showDialog(
                            context: context, 
                            builder: (context) => PlanFormDialog(
                              plan: plan,
                              controller: planController, 
                              dueAt: plan.dueAt
                            )
                          );
                        },
                        onDelete: (context) {
                          planController.delete(plan.id);
                        },
                        addTodo: (context) {
                          showDialog(
                            context: context, 
                            builder: (context) => TodoDialog(
                              planId: plan.id,
                              expiresAt: selectedDate,
                              controller: todoController
                            )
                          );
                        }
                      );
                    })
                  )
                ); 
              })
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context) => PlanFormDialog(controller: planController, dueAt: selectedDate)
          );
        }
      ),
    );
  }
}