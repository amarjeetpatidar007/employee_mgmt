import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../blocs/employee_bloc.dart';
import '../blocs/employee_event.dart';
import '../blocs/employee_state.dart';
import '../model/employee_model.dart';
import '../utils/custom_date_range_picker.dart';


class AddEditEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  const AddEditEmployeeScreen({super.key, this.employee});

  @override
  AddEditEmployeeScreenState createState() => AddEditEmployeeScreenState();
}

class AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  String? selectedRole;
  DateTime selectedStartDate = DateTime.now();
  DateTime? selectedEndDate;
  final List<String> roles = ['Product Designer', 'Flutter Developer', 'QA Tester', 'Product Owner'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    selectedRole = widget.employee?.role;
    _roleController = TextEditingController(text: selectedRole ?? 'Select Role'); // Initialize role controller
    selectedStartDate = widget.employee?.startDate ?? DateTime.now();
    selectedEndDate = widget.employee?.endDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose(); // Dispose role controller
    super.dispose();
  }

  void _showRoleBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return ListView(
          shrinkWrap: true,
          children: roles.map((role) {
            return Card(
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: ListTile(
                title: Center(child: Text(role)),
                onTap: () {
                  setState(() {
                    selectedRole = role;
                    _roleController.text = role; // Update the text field value
                  });
                  Navigator.pop(context);
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _saveEmployee() {
    if (_nameController.text.isEmpty || selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final employeeBloc = context.read<EmployeeBloc>();

    if (widget.employee != null) {
      final updatedEmployee = Employee(
        id: widget.employee!.id,
        name: _nameController.text,
        role: selectedRole!,
        startDate: selectedStartDate,
        endDate: selectedEndDate,
      );
      // print("UPDATE ID UI : ${updatedEmployee.id}");
      employeeBloc.add(UpdateEmployee(updatedEmployee));
    } else {
      // For new employee
      final newEmployee = Employee(
        name: _nameController.text,
        role: selectedRole!,
        startDate: selectedStartDate,
        endDate: selectedEndDate,
      );
      employeeBloc.add(AddEmployee(newEmployee));
    }

    Navigator.pop(context);
  }

  void _deleteEmployee() {
    if (widget.employee != null) {
      final employeeBloc = context.read<EmployeeBloc>();
      employeeBloc.add(DeleteEmployee(widget.employee!.id!));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeBloc, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.employee != null ? 'Edit Employee Details' : 'Add Employee Details'),
          backgroundColor: Colors.blue,
          actionsPadding: EdgeInsets.only(right: 8),
          actions: widget.employee == null ? null :  [
            IconButton(
              icon: Icon(Icons.delete_outline_outlined),
              color: Colors.white,
              onPressed: _deleteEmployee,
            ),
          ],
        ),
        bottomNavigationBar: Card(
          elevation: 0.1,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveEmployee,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
        body: BlocBuilder<EmployeeBloc, EmployeeState>(
          builder: (context, state) {
            if (state is EmployeeLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Employee Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _roleController,
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.work_outline),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      border: OutlineInputBorder(),
                    ),
                    onTap: _showRoleBottomSheet,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => CustomDateRangePicker(
                                isEndDate: false,
                                initialDate: selectedStartDate,
                                onDateSelected: (date) {
                                  setState(() {
                                    selectedStartDate = date;
                                  });
                                },
                              ),
                            );
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Start Date',
                                prefixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(),
                              ),
                              controller: TextEditingController(
                                text: formatDate(selectedStartDate),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                      SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => CustomDateRangePicker(
                                isEndDate: true,
                                initialDate: selectedEndDate ?? selectedStartDate,
                                onDateSelected: (date) {
                                  setState(() {
                                    selectedEndDate = date;
                                  });
                                },
                              ),
                            );
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'End Date',
                                prefixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(),
                              ),
                              controller: TextEditingController(
                                text: selectedEndDate != null
                                    ? formatDate(selectedEndDate!)
                                    : 'No date',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}


