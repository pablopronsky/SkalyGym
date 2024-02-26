// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserClient _$UserClientFromJson(Map<String, dynamic> json) => UserClient(
      json['name'] as String,
      json['lastName'] as String,
      json['email'] as String,
      json['phoneNumber'] as String,
      json['weeklyCredits'] as int,
    );

Map<String, dynamic> _$UserClientToJson(UserClient instance) => <String, dynamic>{
      'name': instance.name,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'weeklyCredits': instance.weeklyCredits,
    };

