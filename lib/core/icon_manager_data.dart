import 'package:budget_app/data/models/models_widget/icon_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconManagerData {
  const IconManagerData._();

  // Essential living icons
  static const IconData _accomodation = Icons.home;
  static const IconData _categoryEating = FontAwesomeIcons.utensils;
  static const IconData _shopping = Icons.shopping_cart;
  static const IconData _transportation = FontAwesomeIcons.bus;
  static const IconData _entertainment = FontAwesomeIcons.gamepad;
  static const IconData _sport = Icons.sports_gymnastics_rounded;
  static const IconData _gift = FontAwesomeIcons.gift;
  static const IconData _water = FontAwesomeIcons.droplet;
  static const IconData _electric = FontAwesomeIcons.bolt;
  static const IconData _phone1 = FontAwesomeIcons.phone;
  static const IconData _phone2 = FontAwesomeIcons.mobileScreenButton;
  static const IconData _house1 = FontAwesomeIcons.house;
  static const IconData _house2 = FontAwesomeIcons.houseChimney;
  static const IconData _baby = FontAwesomeIcons.baby;
  static const IconData _car1 = FontAwesomeIcons.car;
  static const IconData _car2 = FontAwesomeIcons.carSide;

  // Work and productivity icons
  static const IconData _laptop = FontAwesomeIcons.laptop;
  static const IconData _code = FontAwesomeIcons.code;
  static const IconData _pen = FontAwesomeIcons.pen;
  static const IconData _clipboard = FontAwesomeIcons.clipboard;
  static const IconData _book = FontAwesomeIcons.book;

  // Health and fitness icons
  static const IconData _heart = FontAwesomeIcons.heart;
  static const IconData _medical = FontAwesomeIcons.userDoctor;
  static const IconData _pills = FontAwesomeIcons.pills;

  // Travel and transport icons
  static const IconData _plane = FontAwesomeIcons.plane;
  static const IconData _train = FontAwesomeIcons.train;
  static const IconData _truck = FontAwesomeIcons.truck;

  // Entertainment and leisure icons
  static const IconData _music = FontAwesomeIcons.music;
  static const IconData _camera = FontAwesomeIcons.camera;
  static const IconData _tv = FontAwesomeIcons.tv;

  // Miscellaneous icons
  static const IconData _star = FontAwesomeIcons.star;
  static const IconData _key = FontAwesomeIcons.key;
  static const IconData _wifi = FontAwesomeIcons.wifi;
  static const IconData _fire = FontAwesomeIcons.fire;
  static const IconData _rocket = FontAwesomeIcons.rocket;
  static const IconData _fish = FontAwesomeIcons.fish;
  static const IconData _coffee = FontAwesomeIcons.mugSaucer;
  static const IconData _pizza = FontAwesomeIcons.pizzaSlice;

  static final List<IconModel> _listIcon = [
    // Essential living expenses (0-15) - Blue/Teal theme
    IconModel(0, _accomodation, const Color(0xFF2196F3)), // Blue
    IconModel(1, _categoryEating, const Color(0xFF4CAF50)), // Green
    IconModel(2, _shopping, const Color(0xFF9C27B0)), // Purple
    IconModel(3, _transportation, const Color(0xFFFF9800)), // Orange
    IconModel(4, _entertainment, const Color(0xFFE91E63)), // Pink
    IconModel(5, _sport, const Color(0xFF00BCD4)), // Cyan
    IconModel(6, _gift, const Color(0xFFFF5722)), // Deep Orange
    IconModel(7, _water, const Color(0xFF03A9F4)), // Light Blue
    IconModel(8, _electric, const Color(0xFFFFC107)), // Amber
    IconModel(9, _phone1, const Color(0xFF607D8B)), // Blue Grey
    IconModel(10, _phone2, const Color(0xFF795548)), // Brown
    IconModel(11, _house1, const Color(0xFF3F51B5)), // Indigo
    IconModel(12, _house2, const Color(0xFF009688)), // Teal
    IconModel(13, _baby, const Color(0xFFFFEB3B)), // Yellow
    IconModel(14, _car1, const Color(0xFFF44336)), // Red
    IconModel(15, _car2, const Color(0xFF673AB7)), // Deep Purple

    // Work and productivity (16-20) - Professional theme
    IconModel(16, _laptop, const Color(0xFF37474F)), // Dark Grey
    IconModel(17, _code, const Color(0xFF1976D2)), // Blue
    IconModel(18, _pen, const Color(0xFF388E3C)), // Green
    IconModel(19, _clipboard, const Color(0xFF7B1FA2)), // Purple
    IconModel(20, _book, const Color(0xFFD32F2F)), // Red

    // Health and fitness (21-23) - Health theme
    IconModel(21, _heart, const Color(0xFFE53935)), // Red
    IconModel(22, _medical, const Color(0xFF43A047)), // Green
    IconModel(23, _pills, const Color(0xFF5E35B1)), // Deep Purple

    // Travel and transport (24-26) - Travel theme
    IconModel(24, _plane, const Color(0xFF1E88E5)), // Blue
    IconModel(25, _train, const Color(0xFF8E24AA)), // Purple
    IconModel(26, _truck, const Color(0xFF6D4C41)), // Brown

    // Entertainment and leisure (27-29) - Fun theme
    IconModel(27, _music, const Color(0xFF8BC34A)), // Light Green
    IconModel(28, _camera, const Color(0xFFFF7043)), // Deep Orange
    IconModel(29, _tv, const Color(0xFF26A69A)), // Teal

    // Food and dining (30-31) - Food theme
    IconModel(30, _coffee, const Color(0xFF5D4037)), // Brown
    IconModel(31, _pizza, const Color(0xFFFF6F00)), // Orange

    // Miscellaneous (32-35) - Mixed theme
    IconModel(32, _star, const Color(0xFFFDD835)), // Yellow
    IconModel(33, _key, const Color(0xFF424242)), // Grey
    IconModel(34, _wifi, const Color(0xFF00ACC1)), // Cyan
    IconModel(35, _fire, const Color(0xFFD84315)), // Deep Orange
    IconModel(36, _rocket, const Color(0xFF512DA8)), // Deep Purple
    IconModel(37, _fish, const Color(0xFF00838F)), // Dark Cyan
  ];

  static List<IconModel> listIconSelect() {
    return _listIcon.where((e) => e.id < 100).toList();
  }

  static IconModel getIconModel(int iconId) {
    try {
      return _listIcon.firstWhere((e) => e.id == iconId);
    } catch (e) {
      // Return default icon if not found
      return _listIcon.first;
    }
  }

  // Helper method to get icons by category
  static List<IconModel> getIconsByCategory(IconCategory category) {
    switch (category) {
      case IconCategory.essentials:
        return _listIcon.where((e) => e.id >= 0 && e.id <= 15).toList();
      case IconCategory.work:
        return _listIcon.where((e) => e.id >= 16 && e.id <= 20).toList();
      case IconCategory.health:
        return _listIcon.where((e) => e.id >= 21 && e.id <= 23).toList();
      case IconCategory.travel:
        return _listIcon.where((e) => e.id >= 24 && e.id <= 26).toList();
      case IconCategory.entertainment:
        return _listIcon.where((e) => e.id >= 27 && e.id <= 29).toList();
      case IconCategory.food:
        return _listIcon.where((e) => e.id >= 30 && e.id <= 31).toList();
      case IconCategory.miscellaneous:
        return _listIcon.where((e) => e.id >= 32 && e.id <= 37).toList();
    }
  }
}

enum IconCategory {
  essentials,
  work,
  health,
  travel,
  entertainment,
  food,
  miscellaneous,
}
