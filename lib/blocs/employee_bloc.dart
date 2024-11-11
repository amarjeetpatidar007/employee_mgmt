import 'dart:async';
import 'dart:math';

import 'package:employee_management/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/employee_model.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  late final Box<Employee> employeeBox;
  late final StreamSubscription<BoxEvent> _employeeSubscription;

  EmployeeBloc(this.employeeBox) : super(EmployeeInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
    on<EmployeesUpdated>(_onEmployeesUpdated);

    _employeeSubscription = employeeBox.watch().listen((_) {
      add(EmployeesUpdated());
    });
  }

  List<Employee> _getCurrentAndPreviousEmployees() {
    final allEmployees = employeeBox.values.toList();
    final today = DateTime.now();
    allEmployees.sort((a, b) => b.startDate.compareTo(a.startDate));
    return allEmployees;
  }

  void _emitLoadedState(Emitter<EmployeeState> emit) {
    final allEmployees = _getCurrentAndPreviousEmployees();
    final today = DateTime.now();
    final currentEmployees = allEmployees
        .where((e) => e.endDate == null || e.endDate!.isAfter(today))
        .toList();
    final previousEmployees = allEmployees
        .where((e) => e.endDate != null && e.endDate!.isBefore(today))
        .toList();
    emit(EmployeesLoaded(
      currentEmployees: currentEmployees,
      previousEmployees: previousEmployees,
    ));
  }

  Future<void> _onEmployeesUpdated(
      EmployeesUpdated event,
      Emitter<EmployeeState> emit,
      ) async {
    try {
      _emitLoadedState(emit);
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onLoadEmployees(
      LoadEmployees event,
      Emitter<EmployeeState> emit,
      ) async {
    emit(EmployeeLoading());
    try {
      _emitLoadedState(emit);
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onAddEmployee(
      AddEmployee event,
      Emitter<EmployeeState> emit,
      ) async {
    try {
      // Generate a new ID for the employee
      final int newId = await _getNextEmployeeId();
      final newEmployee = Employee(
        id: newId,
        name: event.employee.name,
        role: event.employee.role,
        startDate: event.employee.startDate,
        endDate: event.employee.endDate,
      );
      await employeeBox.add(newEmployee);
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<int> _getNextEmployeeId() async {
    final keys = await employeeBox.keys.toList();
    if (keys.isEmpty) {
      return 1;
    } else {
      final maxId = keys.cast<int>().reduce(max);
      return maxId + 1;
    }
  }

  Future<void> _onUpdateEmployee(
      UpdateEmployee event,
      Emitter<EmployeeState> emit,
      ) async {
    try {
      final key = await employeeBox.keys.firstWhere((k) => employeeBox.get(k)?.id == event.employee.id);
      await employeeBox.put(key, event.employee);
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onDeleteEmployee(
      DeleteEmployee event,
      Emitter<EmployeeState> emit,
      ) async {
    try {
      final key = await employeeBox.keys.firstWhere((k) => employeeBox.get(k)?.id == event.employeeId);
      await employeeBox.delete(key);
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _employeeSubscription.cancel();
    return super.close();
  }
}