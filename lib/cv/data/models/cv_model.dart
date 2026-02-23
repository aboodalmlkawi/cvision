import 'package:cloud_firestore/cloud_firestore.dart';

class CVModel {
  final String id;
  final String userId;
  final String templateId;
  final String title;
  final PersonalInfo personalInfo;
  final List<Education> education;
  final List<Experience> experience;
  final List<String> skills;
  final List<String> languages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int score;

  CVModel({
    required this.id,
    required this.userId,
    required this.templateId,
    required this.title,
    required this.personalInfo,
    required this.education,
    required this.experience,
    required this.skills,
    required this.languages,
    required this.createdAt,
    required this.updatedAt,
    this.score = 0,
  });

  String get summary => personalInfo.summary;

  CVModel copyWith({
    String? id,
    String? userId,
    String? templateId,
    String? title,
    PersonalInfo? personalInfo,
    List<Education>? education,
    List<Experience>? experience,
    List<String>? skills,
    List<String>? languages,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? score,
  }) {
    return CVModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      templateId: templateId ?? this.templateId,
      title: title ?? this.title,
      personalInfo: personalInfo ?? this.personalInfo,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      score: score ?? this.score,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'templateId': templateId,
      'title': title,
      'personalInfo': personalInfo.toMap(),
      'education': education.map((x) => x.toMap()).toList(),
      'experience': experience.map((x) => x.toMap()).toList(),
      'skills': skills,
      'languages': languages,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'score': score,
    };
  }

  factory CVModel.fromMap(Map<String, dynamic> map, String docId) {
    return CVModel(
      id: docId,
      userId: map['userId'] ?? '',
      templateId: map['templateId'] ?? 'modern',
      title: map['title'] ?? 'My CV',
      personalInfo: PersonalInfo.fromMap(map['personalInfo'] ?? {}),
      education: List<Education>.from((map['education'] ?? []).map((x) => Education.fromMap(x))),
      experience: List<Experience>.from((map['experience'] ?? []).map((x) => Experience.fromMap(x))),
      skills: List<String>.from(map['skills'] ?? []),
      languages: List<String>.from(map['languages'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      score: map['score']?.toInt() ?? 0,
    );
  }
}

class PersonalInfo {
  final String fullName;
  final String email;
  final String phone;
  final String jobTitle;
  final String summary;
  final String address;
  final String linkedin;
  final String website;
  final String? photoUrl;

  PersonalInfo({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.jobTitle,
    this.summary = '',
    this.address = '',
    this.linkedin = '',
    this.website = '',
    this.photoUrl,
  });

  Map<String, dynamic> toMap() => {
    'fullName': fullName, 'email': email, 'phone': phone, 'jobTitle': jobTitle,
    'summary': summary, 'address': address, 'linkedin': linkedin, 'website': website, 'photoUrl': photoUrl,
  };

  factory PersonalInfo.fromMap(Map<String, dynamic> map) => PersonalInfo(
    fullName: map['fullName'] ?? '', email: map['email'] ?? '', phone: map['phone'] ?? '',
    jobTitle: map['jobTitle'] ?? '', summary: map['summary'] ?? '', address: map['address'] ?? '',
    linkedin: map['linkedin'] ?? '', website: map['website'] ?? '', photoUrl: map['photoUrl'],
  );
}

class Education {
  final String schoolName;
  final String degree;
  final String startDate;
  final String endDate;
  final String description;

  Education({
    required this.schoolName,
    required this.degree,
    required this.startDate,
    required this.endDate,
    this.description = '',
  });

  Map<String, dynamic> toMap() => {
    'schoolName': schoolName,
    'degree': degree,
    'startDate': startDate,
    'endDate': endDate,
    'description': description,
  };

  factory Education.fromMap(Map<String, dynamic> map) => Education(
    schoolName: map['schoolName'] ?? map['school'] ?? '',
    degree: map['degree'] ?? '',
    startDate: map['startDate'] ?? '',
    endDate: map['endDate'] ?? '',
    description: map['description'] ?? '',
  );
}

class Experience {
  final String companyName;
  final String jobTitle;
  final String description;
  final String startDate;
  final String endDate;

  Experience({
    required this.companyName,
    required this.jobTitle,
    required this.description,
    required this.startDate,
    required this.endDate
  });

  Map<String, dynamic> toMap() => {
    'companyName': companyName,
    'jobTitle': jobTitle,
    'description': description,
    'startDate': startDate,
    'endDate': endDate
  };

  factory Experience.fromMap(Map<String, dynamic> map) => Experience(
    companyName: map['companyName'] ?? map['company'] ?? '',
    jobTitle: map['jobTitle'] ?? map['position'] ?? '',
    description: map['description'] ?? '',
    startDate: map['startDate'] ?? '',
    endDate: map['endDate'] ?? '',
  );
}