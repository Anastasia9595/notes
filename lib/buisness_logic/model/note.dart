// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_quill/flutter_quill.dart';

class Note extends Equatable {
  final int id;
  final String title;
  final String description;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isNoteSelected;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    this.isNoteSelected = false,
  });

  Note copyWith({
    int? id,
    String? title,
    String? description,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isNoteSelected,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isNoteSelected: isNoteSelected ?? this.isNoteSelected,
    );
  }

  // from map to object
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        isFavorite: map['isFavorite'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']));
  }

  // from object to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isFavorite': isFavorite,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, title, description, isFavorite, createdAt, updatedAt, isNoteSelected];
}
