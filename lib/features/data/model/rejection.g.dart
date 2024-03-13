// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rejection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rejection _$RejectionFromJson(Map<String, dynamic> json) => Rejection(
      json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      weight: json['weight'] as String?,
      set: json['set'] as String?,
      rejectionQuantity: json['rejectionQuantity'] as String?,
      id: json['id'] as String?,
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      date: json['date'] as String?,
      employee: json['employee'] == null
          ? null
          : Employee.fromJson(json['employee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RejectionToJson(Rejection instance) => <String, dynamic>{
      'id': instance.id,
      'customer': instance.customer,
      'location': instance.location,
      'product': instance.product,
      'employee': instance.employee,
      'date': instance.date,
      'weight': instance.weight,
      'set': instance.set,
      'rejectionQuantity': instance.rejectionQuantity,
    };
