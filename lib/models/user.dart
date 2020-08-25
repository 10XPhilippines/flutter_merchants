import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<User> fetchAlbum() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return User.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class User {
  int id;
  String name;
  String email;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  String userType;
  String verification;
  String isVerified;
  String image;
  String provider;
  String providerId;
  Null username;
  Null sex;
  Null city;
  Null province;
  Null zip;
  Null about;
  Null dealCounter;
  String businessCounter;
  Null keywordsCounter;
  Null isUpgraded;
  Null phone;

  User(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.userType,
      this.verification,
      this.isVerified,
      this.image,
      this.provider,
      this.providerId,
      this.username,
      this.sex,
      this.city,
      this.province,
      this.zip,
      this.about,
      this.dealCounter,
      this.businessCounter,
      this.keywordsCounter,
      this.isUpgraded,
      this.phone});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userType = json['user_type'];
    verification = json['verification'];
    isVerified = json['is_verified'];
    image = json['image'];
    provider = json['provider'];
    providerId = json['provider_id'];
    username = json['username'];
    sex = json['sex'];
    city = json['city'];
    province = json['province'];
    zip = json['zip'];
    about = json['about'];
    dealCounter = json['deal_counter'];
    businessCounter = json['business_counter'];
    keywordsCounter = json['keywords_counter'];
    isUpgraded = json['is_upgraded'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_type'] = this.userType;
    data['verification'] = this.verification;
    data['is_verified'] = this.isVerified;
    data['image'] = this.image;
    data['provider'] = this.provider;
    data['provider_id'] = this.providerId;
    data['username'] = this.username;
    data['sex'] = this.sex;
    data['city'] = this.city;
    data['province'] = this.province;
    data['zip'] = this.zip;
    data['about'] = this.about;
    data['deal_counter'] = this.dealCounter;
    data['business_counter'] = this.businessCounter;
    data['keywords_counter'] = this.keywordsCounter;
    data['is_upgraded'] = this.isUpgraded;
    data['phone'] = this.phone;
    return data;
  }
}
