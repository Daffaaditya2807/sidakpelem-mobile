import 'dart:convert';

class UserModel {
  const UserModel({
    this.id,
    this.nik,
    this.name,
    this.tempatLahir,
    this.tanggalLahir,
    this.email,
    this.role,
    this.jabatan,
    this.phone,
    this.noTelepon,
    this.employeeId,
    this.status,
    this.address,
    this.alamat,
    this.hireDate,
    this.jenisKelamin,
    this.urlPhoto,
    this.password,
  });

  final int? id;
  final String? nik;
  final String? name;
  final String? tempatLahir;
  final String? tanggalLahir;
  final String? email;
  final String? role;
  final String? jabatan;
  final String? phone;
  final String? noTelepon;
  final String? employeeId;
  final String? status;
  final String? address;
  final String? alamat;
  final String? hireDate;
  final String? jenisKelamin;
  final String? urlPhoto;
  final String? password;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _parseInt(json['id']),
      nik: json['nik']?.toString(),
      name: json['name']?.toString(),
      tempatLahir: json['tempat_lahir']?.toString(),
      tanggalLahir: json['tanggal_lahir']?.toString(),
      email: json['email']?.toString(),
      role: json['role']?.toString(),
      jabatan: json['jabatan']?.toString(),
      phone: json['phone']?.toString(),
      noTelepon: json['no_telepon']?.toString(),
      employeeId: json['employee_id']?.toString(),
      status: json['status']?.toString(),
      address: json['address']?.toString(),
      alamat: json['alamat']?.toString(),
      hireDate: json['hire_date']?.toString(),
      jenisKelamin: json['jenis_kelamin']?.toString(),
      urlPhoto: json['url_photo']?.toString(),
      password: json['password']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nik': nik,
      'name': name,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir,
      'email': email,
      'role': role,
      'jabatan': jabatan,
      'phone': phone,
      'no_telepon': noTelepon,
      'employee_id': employeeId,
      'status': status,
      'address': address,
      'alamat': alamat,
      'hire_date': hireDate,
      'jenis_kelamin': jenisKelamin,
      'url_photo': urlPhoto,
      'password': password,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory UserModel.fromJsonString(String source) {
    return UserModel.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }

  UserModel copyWith({
    int? id,
    String? nik,
    String? name,
    String? tempatLahir,
    String? tanggalLahir,
    String? email,
    String? role,
    String? jabatan,
    String? phone,
    String? noTelepon,
    String? employeeId,
    String? status,
    String? address,
    String? alamat,
    String? hireDate,
    String? jenisKelamin,
    String? urlPhoto,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      nik: nik ?? this.nik,
      name: name ?? this.name,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      email: email ?? this.email,
      role: role ?? this.role,
      jabatan: jabatan ?? this.jabatan,
      phone: phone ?? this.phone,
      noTelepon: noTelepon ?? this.noTelepon,
      employeeId: employeeId ?? this.employeeId,
      status: status ?? this.status,
      address: address ?? this.address,
      alamat: alamat ?? this.alamat,
      hireDate: hireDate ?? this.hireDate,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      urlPhoto: urlPhoto ?? this.urlPhoto,
      password: password ?? this.password,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    return int.tryParse(value.toString());
  }
}
