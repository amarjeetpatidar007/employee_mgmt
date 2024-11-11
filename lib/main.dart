import 'package:employee_management/model/employee_model.dart';
import 'package:employee_management/screens/add_edit_employee_screen.dart';
import 'package:employee_management/screens/employee_list_screen.dart';
import 'package:employee_management/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import 'blocs/employee_bloc.dart';
import 'blocs/employee_event.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());
  final employeeBox = await Hive.openBox<Employee>('employees');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<Box<Employee>>(
      create: (_) => Hive.box<Employee>('employees'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => EmployeeBloc(RepositoryProvider.of<Box<Employee>>(context))
              ..add(LoadEmployees()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const EmployeeListScreen(),
        ),
      ),
    );
  }
}


//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         // BlocProvider(create: (_) => EmployeeBloc()..add(LoadEmployees())),
//         BlocProvider(create: (_) => EmployeeBloc()),
//
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: AppTheme.lightTheme,
//         home: EmployeeListScreen(),
//       ),
//     );
//   }
// }
