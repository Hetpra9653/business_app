import 'package:business_app/features/data/model/customer.dart';
import 'package:business_app/features/data/model/location.dart';
import 'package:business_app/features/data/model/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  final String? id;
  final Customer? Customername;
  final LocationModel? location;
  final Product? product;
  final String? employee;
  final String? date;
  final String? orderQuantity;

  Order({
    this.Customername,
    this.product,
    this.orderQuantity,
    this.id,
    this.location,
    this.date,
    this.employee,
  });
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
