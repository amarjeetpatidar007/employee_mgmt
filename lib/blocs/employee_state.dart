import 'package:equatable/equatable.dart';

import '../model/employee_model.dart';

abstract class EmployeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeesLoaded extends EmployeeState {
  final List<Employee> currentEmployees;
  final List<Employee> previousEmployees;

  EmployeesLoaded({
    required this.currentEmployees,
    required this.previousEmployees,
  });

  @override
  List<Object?> get props => [currentEmployees, previousEmployees];
}

class EmployeeError extends EmployeeState {
  final String message;

  EmployeeError(this.message);

  @override
  List<Object?> get props => [message];
}
