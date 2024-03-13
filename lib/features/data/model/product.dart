import 'package:business_app/features/data/model/employee.dart';
import 'package:business_app/features/data/model/location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product{
  final String? id;
  final String? name;
  final LocationModel? location;
  final String? date;
  final Employee? employee;
  final String? weight;
  final String? set;

    Product({this.id, this.name, this.location, this.date, this.employee, this.weight, this.set});
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);


  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
