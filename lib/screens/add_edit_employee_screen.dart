import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../blocs/employee_bloc.dart';
import '../blocs/employee_event.dart';
import '../blocs/employee_state.dart';
import '../model/employee_model.dart';
import '../utils/custom_date_range_picker.dart';

// class AddEditEmployeeScreen extends StatefulWidget {
//   final Employee? employee;
//
//   const AddEditEmployeeScreen({super.key, this.employee});
//
//   @override
//   _AddEditEmployeeScreenState createState() => _AddEditEmployeeScreenState();
// }
//
// class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
//   late TextEditingController _nameController;
//   late TextEditingController _roleController;
//   late DateTime _startDate;
//   DateTime? _endDate;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.employee?.name ?? '');
//     _roleController = TextEditingController(text: widget.employee?.role ?? '');
//     _startDate = widget.employee?.startDate ?? DateTime.now();
//     _endDate = widget.employee?.endDate;
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _roleController.dispose();
//     super.dispose();
//   }
//
//   bool _validateInputs() {
//     if (_nameController.text.isEmpty || _roleController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please fill in all fields')),
//       );
//       return false;
//     }
//     return true;
//   }
//
//   void _saveEmployee() {
//     if (!_validateInputs()) return;
//
//     final employee = Employee(
//       // id: widget.employee?.id ?? 0,
//       name: _nameController.text,
//       role: _roleController.text,
//       startDate: _startDate,
//       endDate: _endDate,
//     );
//
//     if (widget.employee == null) {
//       context.read<EmployeeBloc>().add(AddEmployee(employee));
//     } else {
//       context.read<EmployeeBloc>().add(UpdateEmployee(employee));
//     }
//
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<EmployeeBloc, EmployeeState>(
//       listener: (context, state) {
//         if (state is EmployeeError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.employee == null ? 'New Employee' : 'Edit Employee'),
//           actions: [
//             if (widget.employee != null)
//               IconButton(
//                 icon: Icon(Icons.delete),
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: Text('Delete Employee'),
//                       content: Text('Are you sure you want to delete this employee?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: Text('Cancel'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             context.read<EmployeeBloc>().add(
//                               DeleteEmployee(widget.employee!.id),
//                             );
//                             Navigator.pop(context); // Close dialog
//                             Navigator.pop(context); // Close screen
//                           },
//                           style: TextButton.styleFrom(foregroundColor: Colors.red),
//                           child: Text('Delete'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               TextField(
//                 controller: _roleController,
//                 decoration: InputDecoration(
//                   labelText: 'Role',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               _buildDateRow('Start Date', _startDate, (date) {
//                 setState(() => _startDate = date);
//               }),
//               SizedBox(height: 16.0),
//               _buildDateRow('End Date', _endDate, (date) {
//                 setState(() => _endDate = date);
//               }, allowNull: true),
//               Expanded(
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: Text('Cancel'),
//                       ),
//                       SizedBox(width: 8),
//                       ElevatedButton(
//                         onPressed: _saveEmployee,
//                         child: Text(widget.employee == null ? 'Create' : 'Save'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateRow(
//       String label,
//       DateTime? date,
//       Function(DateTime) onDateSelected, {
//         bool allowNull = false,
//       }) {
//     return Row(
//       children: [
//         Text('$label: '),
//         SizedBox(width: 8.0),
//         Expanded(
//           child: Text(date?.toString().split(' ')[0] ?? 'Not set'),
//         ),
//         if (allowNull && date != null)
//           IconButton(
//             icon: Icon(Icons.clear),
//             onPressed: () => setState(() => _endDate = null),
//           ),
//         ElevatedButton(
//           onPressed: () async {
//             final selectedDate = await showDatePicker(
//               context: context,
//               initialDate: date ?? DateTime.now(),
//               firstDate: DateTime(2000),
//               lastDate: DateTime(2100),
//             );
//             if (selectedDate != null) {
//               onDateSelected(selectedDate);
//             }
//           },
//           child: Text('Select Date'),
//         ),
//       ],
//     );
//   }
// }
//
//




// add_edit_employee_screen.dart


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
      employeeBloc.add(DeleteEmployee(widget.employee!.id));
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


