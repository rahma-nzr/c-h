// lib/models/job_offer_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class JobOffer {
  final String jobID;
  final String nameBusinessOwner;
  final String title;
  final String description;
  final String duration;
  final String budget;
  final List<String> skills;
  final DateTime? createdAt;

  JobOffer({
    required this.jobID,
    required this.nameBusinessOwner,
    required this.title,
    required this.description,
    required this.duration,
    required this.budget,
    this.skills = const [],
    this.createdAt,
  });

  factory JobOffer.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return JobOffer(
      jobID: doc.id,
      nameBusinessOwner: data['nameBusinessOwner'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      duration: data['duration'] ?? '',
      budget: data['budget'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      createdAt: data['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nameBusinessOwner': nameBusinessOwner,
      'title': title,
      'description': description,
      'duration': duration,
      'budget': budget,
      'skills': skills,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}