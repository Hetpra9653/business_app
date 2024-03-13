import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';

@JsonSerializable()
class Employee {
  final String? id;
  final String? name;
  final String? location;
  final String? birthdate;
  final String? currentAddress;
  final String? createdBy;
  final String? joiningDate;
  final String? salary;
  final String? aadharNumber;
  final String? phonenumber;
  final String? mode;
  final int? moldNumber;
  final String? employeeImage;

  Employee({this.salary, this.aadharNumber, this.phonenumber,
    this.joiningDate,
    this.birthdate,
    this.employeeImage,
    this.id,
    this.name,
    this.location,
    this.currentAddress,
    this.createdBy,
    this.mode,
    this.moldNumber,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
