// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispatch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dispatch _$DispatchFromJson(Map<String, dynamic> json) => Dispatch(
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as String?,
      orderRemainingQuantity: json['orderRemainingQuantity'] as String?,
      billNo: json['billNo'] as String?,
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      id: json['id'] as String?,
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      date: json['date'] as String?,
      employee: json['employee'] == null
          ? null
          : Employee.fromJson(json['employee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DispatchToJson(Dispatch instance) => <String, dynamic>{
      'id': instance.id,
      'customer': instance.customer,
      'location': instance.location,
      'product': instance.product,
      'employee': instance.employee,
      'date': instance.date,
      'quantity': instance.quantity,
      'orderRemainingQuantity': instance.orderRemainingQuantity,
      'billNo': instance.billNo,
    };
