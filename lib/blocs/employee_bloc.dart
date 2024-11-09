import 'package:employee_management/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/employee_model.dart';
import '../objectbox.dart';
import 'dart:async';

import '../objectbox.g.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final Box<Employee> employeeBox = objectbox.store.box<Employee>();
  late final StreamSubscription<Query<Employee>> _employeeSubscription;

  EmployeeBloc() : super(EmployeeInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
    on<EmployeesUpdated>(_onEmployeesUpdated);

    final query = employeeBox.query().watch();
    _employeeSubscription = query.listen((_) {
      add(EmployeesUpdated());
    });
  }

  List<Employee> _getCurrentAndPreviousEmployees() {
    final allEmployees = employeeBox.getAll();
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
      // Check
      if (event.employee.id != 0) {
        final existingEmployee = employeeBox.get(event.employee.id);
        if (existingEmployee != null) {
          // Update existing employee
          employeeBox.put(event.employee);
          return;
        }
      }
      // Add
      employeeBox.put(event.employee);
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onUpdateEmployee(
      UpdateEmployee event,
      Emitter<EmployeeState> emit,
      ) async {
    try {
      // print("UPDATE ID BLOC: ${event.employee.id}"); // Debug print
      final existingEmployee = employeeBox.get(event.employee.id);
      if (existingEmployee != null) {
        final updatedEmployee = Employee(
          id: event.employee.id, // Preserve the ID
          name: event.employee.name,
          role: event.employee.role,
          startDate: event.employee.startDate,
          endDate: event.employee.endDate,
        );

        employeeBox.put(updatedEmployee);
      } else {
        emit(EmployeeError('Employee not found'));
      }
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }


  Future<void> _onDeleteEmployee(
      DeleteEmployee event,
      Emitter<EmployeeState> emit,
      ) async {
    try {
      employeeBox.remove(event.employeeId);
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