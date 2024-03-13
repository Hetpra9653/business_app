import 'package:business_app/features/data/model/customer.dart';
import 'package:business_app/features/data/model/employee.dart';
import 'package:business_app/features/data/model/location.dart';
import 'package:business_app/features/data/model/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dispatch.g.dart';

@JsonSerializable()
class Dispatch{
  final String? id;
  final Customer? customer;
  final LocationModel? location;
  final Product? product;
  final Employee? employee;
  final String? date;
  final String? quantity;
    final String? orderRemainingQuantity;
  final String? billNo;

    Dispatch({this.product, this.quantity, this.orderRemainingQuantity,this.billNo, this.customer,  this.id,  this.location, this.date, this.employee,});
  factory Dispatch.fromJson(Map<String, dynamic> json) => _$DispatchFromJson(json);


  Map<String, dynamic> toJson() => _$DispatchToJson(this);
}
