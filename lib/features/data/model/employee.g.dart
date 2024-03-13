// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      salary: json['salary'] as String?,
      aadharNumber: json['aadharNumber'] as String?,
      phonenumber: json['phonenumber'] as String?,
      joiningDate: json['joiningDate'] as String?,
      birthdate: json['birthdate'] as String?,
      employeeImage: json['employeeImage'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      location: json['location'] as String?,
      currentAddress: json['currentAddress'] as String?,
      createdBy: json['createdBy'] as String?,
      mode: json['mode'] as String?,
      moldNumber: json['moldNumber'] as int?,
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'birthdate': instance.birthdate,
      'currentAddress': instance.currentAddress,
      'createdBy': instance.createdBy,
      'joiningDate': instance.joiningDate,
      'salary': instance.salary,
      'aadharNumber': instance.aadharNumber,
      'phonenumber': instance.phonenumber,
      'mode': instance.mode,
      'moldNumber': instance.moldNumber,
      'employeeImage': instance.employeeImage,
    };
