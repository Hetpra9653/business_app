import 'package:business_app/features/data/model/customer.dart';
import 'package:business_app/features/data/model/employee.dart';
import 'package:business_app/features/data/model/location.dart';
import 'package:business_app/features/data/model/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rejection.g.dart';

@JsonSerializable()
class Rejection{
  final String? id;
  final Customer? customer;
  final LocationModel? location;
  final Product? product;
  final Employee? employee;
  final String? date;
  final String? weight;
    final String? set;
  final String? rejectionQuantity;

    Rejection(this.customer, this.product, {this.weight, this.set,this.rejectionQuantity,  this.id,  this.location, this.date, this.employee,});
  factory Rejection.fromJson(Map<String, dynamic> json) => _$RejectionFromJson(json);


  Map<String, dynamic> toJson() => _$RejectionToJson(this);
}
