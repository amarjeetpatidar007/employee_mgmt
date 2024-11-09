import 'package:flutter/material.dart';

class NoEmployeeFoundWidget extends StatelessWidget {
  const NoEmployeeFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.search_off_outlined, size: 100,),
            Text("No employee records found", style: TextStyle(
              fontWeight: FontWeight.w600
            ),)
          ],
      ),
    );
  }
}
