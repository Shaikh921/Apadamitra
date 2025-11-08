
enum UserRole { user, admin, authority }

class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? phoneNumber;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String languageCode;
  final bool notificationsEnabled;
  final List<String> emergencyContacts;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.role = UserRole.user,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.address,
    this.languageCode = 'en',
    this.notificationsEnabled = true,
    this.emergencyContacts = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
    role: UserRole.values.firstWhere(
      (e) => e.name == (json['role'] as String),
      orElse: () => UserRole.user,
    ),
    phoneNumber: json['phone_number'] as String?,
    latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
    longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
    address: json['address'] as String?,
    languageCode: json['language_code'] as String? ?? 'en',
    notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
    emergencyContacts: (json['emergency_contacts'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'role': role.name,
    'phone_number': phoneNumber,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'language_code': languageCode,
    'notifications_enabled': notificationsEnabled,
    'emergency_contacts': emergencyContacts,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? phoneNumber,
    double? latitude,
    double? longitude,
    String? address,
    String? languageCode,
    bool? notificationsEnabled,
    List<String>? emergencyContacts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserModel(
    id: id ?? this.id,
    email: email ?? this.email,
    name: name ?? this.name,
    role: role ?? this.role,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    address: address ?? this.address,
    languageCode: languageCode ?? this.languageCode,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    emergencyContacts: emergencyContacts ?? this.emergencyContacts,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
