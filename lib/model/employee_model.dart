import 'package:objectbox/objectbox.dart';

@Entity()
class Employee {
  @Id()
  int id;

  String name;
  String role;
  DateTime startDate;
  DateTime? endDate;

  Employee({
    this.id = 0,
    required this.name,
    required this.role,
    required this.startDate,
    this.endDate,
  });

  Employee copyWith({
    int? id,
    String? name,
    String? role,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Employee &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              role == other.role &&
              startDate == other.startDate &&
              endDate == other.endDate;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      role.hashCode ^
      startDate.hashCode ^
      (endDate?.hashCode ?? 0);

  @override
  String toString() {
    return 'Employee{id: $id, name: $name, role: $role, startDate: $startDate, endDate: $endDate}';
  }
}