// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      Customername: json['Customername'] == null
          ? null
          : Customer.fromJson(json['Customername'] as Map<String, dynamic>),
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      orderQuantity: json['orderQuantity'] as String?,
      id: json['id'] as String?,
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      date: json['date'] as String?,
      employee: json['employee'] as String?,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'Customername': instance.Customername,
      'location': instance.location,
      'product': instance.product,
      'employee': instance.employee,
      'date': instance.date,
      'orderQuantity': instance.orderQuantity,
    };
