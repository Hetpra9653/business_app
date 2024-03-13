import 'package:business_app/features/data/model/location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  final String? id;
  final String? name;
  final LocationModel? location;
  Customer({
    this.id,
    this.name,
    this.location,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>_$CustomerFromJson(json);
  Map<String, dynamic> toJson () => _$CustomerToJson(this);
}
