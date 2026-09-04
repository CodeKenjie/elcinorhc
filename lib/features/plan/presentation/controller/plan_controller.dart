import 'package:flutter/foundation.dart';
import '../../domain/entities/plan.dart';
import '../../domain/usecases/get_plans.dart';
import '../../domain/usecases/create_plan.dart';
import '../../domain/usecases/update_plan.dart';
import '../../domain/usecases/update_plan_status.dart';
import '../../domain/usecases/delete_plan.dart';

class PlanController extends ChangeNotifier {
  final GetPlans getPlansUseCase;
  final CreatePlan createPlanUseCase;
  final UpdatePlan updatePlanUseCase;
  final UpdatePlanStatus updatePlanStatusUseCase;
  final DeletePlan deletePlanUseCase;

  PlanController({
    required this.getPlansUseCase,
    required this.createPlanUseCase,
    required this.updatePlanUseCase,
    required this.updatePlanStatusUseCase,
    required this.deletePlanUseCase
  });

  List<Plan> _plans = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Plan> get plans => _plans;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  String _formattedError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  Future<bool> getAll() async {
    _clearError();
    _setLoading(true);
    try {
      _plans = List<Plan>.from(await getPlansUseCase());
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> create ({ 
    required String title,
    String? body,
    required DateTime dueAt
  }) async {
    _clearError();
    _setLoading(true);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if(title.isEmpty) {
      _errorMessage = "Title can't be blank.";
      return false;
    }

    if(dueAt.isBefore(today)) {
      _errorMessage = "The date cannot be less than the current time";
      return false;
    }

    try {
      final plan = await createPlanUseCase(
        title: title,
        body: body,
        dueAt: dueAt
      );

      _plans.add(plan);
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> update ({
    required int id,
    required String title,
    String? body,
    required DateTime dueAt,
  }) async {
    _clearError();
    _setLoading(true);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if(dueAt.isBefore(today)) {
      _errorMessage = "The date cannot be less than the current time";
      return false;
    }

    if(title.isEmpty) {
      _errorMessage = "Title can't be blank.";
      return false;
    }

    try {
      await updatePlanUseCase(
        id: id,
        title: title,
        body: body,
        dueAt: dueAt
      );
      final index = _plans.indexWhere((plan) => plan.id == id);
      if (index != -1) {
        _plans[index] = _plans[index].copyWith(
          title: title,
          body: body,
          dueAt: dueAt
        );
      }

      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateStatus ({
    required int id,
    required bool completed
  }) async {
    _clearError();
    _setLoading(true);

    try {
      await updatePlanStatusUseCase(
        id: id,
        completed: completed
      );
      final index = _plans.indexWhere((plan) => plan.id == id);
      if (index != -1) {
        _plans[index] = _plans[index].copyWith(
          completed: completed
        );
      }

      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> delete(int id) async {
    _clearError();
    _setLoading(true);

    try {
      await deletePlanUseCase(id);
      _plans.removeWhere((plan) => plan.id == id);
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
