import 'package:employee_management/utils/no_employee_found.dart';
import 'package:employee_management/screens/add_edit_employee_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../blocs/employee_bloc.dart';
import '../blocs/employee_event.dart';
import '../blocs/employee_state.dart';
import '../model/employee_model.dart';
import '../main.dart';
import '../utils/custom_date_range_picker.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc(RepositoryProvider.of<Box<Employee>>(context))..add(LoadEmployees()),
      child: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is EmployeeError) {
            return Center(child: Text(state.message));
          }

          if (state is EmployeesLoaded) {
            print(state.currentEmployees);
            return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              appBar: AppBar(
                title: Text('Employee List'),
                backgroundColor: Colors.blue,
              ),
              body: state.currentEmployees.isEmpty &&
                      state.previousEmployees.isEmpty
                  ? NoEmployeeFoundWidget()
                  : Stack(
                      children: [
                        ListView(children: [
                          if (state.currentEmployees.isNotEmpty)
                            _buildSectionTitle(context, 'Current employees'),
                          ...state.currentEmployees.map((employee) =>
                              _buildEmployeeTile(employee, context)),
                          if (state.previousEmployees.isNotEmpty)
                            _buildSectionTitle(context, 'Previous employees'),
                          ...state.previousEmployees.map((employee) =>
                              _buildEmployeeTile(employee, context)),
                          SizedBox(height: 60),
                        ]),
                        Positioned(
                          bottom: 40,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            child: Text(
                              'Swipe left to delete',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            AddEditEmployeeScreen(employee: null)),
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.add),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildEmployeeTile(Employee employee, BuildContext context) {
    final startDateStr = formatDate(employee.startDate);
    final endDateStr =
        employee.endDate != null ? ' - ${formatDate(employee.endDate!)}' : '';

    return Dismissible(
      key: ValueKey(employee.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        context.read<EmployeeBloc>().add(DeleteEmployee(employee.id!));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.fixed,
            content: Text('Employee data has been deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                context.read<EmployeeBloc>().add(AddEmployee(employee));
              },
            ),
          ),
        );
      },
      child: Card(
        elevation: 0,
        margin: EdgeInsets.all(1),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddEditEmployeeScreen(employee: employee)),
            );
          },
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              employee.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(employee.role, style: TextStyle(color: Colors.grey)),
              Text('From $startDateStr$endDateStr',
                  style: TextStyle(color: Colors.grey)),
              SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      color: Colors.grey[200],
      child: Text(
        title,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
