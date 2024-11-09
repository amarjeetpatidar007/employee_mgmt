import 'package:employee_management/screens/add_edit_employee_screen.dart';
import 'package:employee_management/screens/employee_list_screen.dart';
import 'package:employee_management/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/employee_bloc.dart';
import 'blocs/employee_event.dart';
import 'objectbox.dart';

late ObjectBox objectbox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => EmployeeBloc()..add(LoadEmployees())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: EmployeeListScreen(),
      ),
    );
  }
}
