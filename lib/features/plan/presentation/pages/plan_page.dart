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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Padding (
        padding: const EdgeInsets.all(10),
          child: ListView (
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
                  color:Theme.of(context).colorScheme.tertiary
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
                      padding: const EdgeInsets.all(0),
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'No plans for this date.',
                                  style: TextStyle(
                                    fontSize: 24, 
                                    fontWeight: FontWeight.bold, 
                                    color: Theme.of(context).colorScheme.tertiary
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Long press the date, or click the add "+" button to create a plan.',
                                  style: TextStyle(
                                    fontSize: 16, 
                                    color: Theme.of(context).colorScheme.tertiary
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]
                      )
                    );
                  }
                  return Container(
                    padding: const EdgeInsets.all(0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: plans.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 5);
                      },
                      itemBuilder: ((context, index) {
                        final plan = plans[index];

                        return PlanCard(
                          plan: plan,
                          todoController: todoController,
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
                          addTodo: () {
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
        backgroundColor: const Color.fromARGB(255, 76, 175, 142),
        child: const Icon(Icons.add),
        onPressed: () {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          if(selectedDate.isBefore(today)) {
            selectedDate = now;
          }

          showDialog(
            context: context, 
            builder: (context) => PlanFormDialog(controller: planController, dueAt: selectedDate)
          );
        }
      ),
    );
  }
}