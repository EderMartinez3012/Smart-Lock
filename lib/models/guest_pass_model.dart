import 'package:flutter/material.dart';

class GuestPass {
  final String id;
  final String guestName;
  final String code;
  final DateTime expiryDate;

  GuestPass({
    required this.id,
    required this.guestName,
    required this.code,
    required this.expiryDate,
  });
}
