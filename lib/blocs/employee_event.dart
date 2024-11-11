import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/employee_model.dart';


abstract class EmployeeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final Employee employee;

  AddEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

class UpdateEmployee extends EmployeeEvent {
  final Employee employee;

  UpdateEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

class DeleteEmployee extends EmployeeEvent {
  final int employeeId;

  DeleteEmployee(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}

class EmployeesUpdated extends EmployeeEvent {}
