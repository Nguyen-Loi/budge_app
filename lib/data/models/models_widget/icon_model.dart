import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum IconCategory {
  essentials,
  work,
  health,
  travel,
  entertainment,
  food,
  miscellaneous,
  unknown;

  String get displayName {
    switch (this) {
      case IconCategory.essentials:
        return 'Essentials';
      case IconCategory.work:
        return 'Work';
      case IconCategory.health:
        return 'Health';
      case IconCategory.travel:
        return 'Travel';
      case IconCategory.entertainment:
        return 'Entertainment';
      case IconCategory.food:
        return 'Food';
      case IconCategory.miscellaneous:
        return 'Miscellaneous';
      case IconCategory.unknown:
        return 'Unknown';
    }
  }

  Color get defaultColor {
    switch (this) {
      case IconCategory.essentials:
        return const Color(0xFF2196F3); // Blue
      case IconCategory.work:
        return const Color(0xFF37474F); // Dark Grey
      case IconCategory.health:
        return const Color(0xFFE53935); // Red
      case IconCategory.travel:
        return const Color(0xFF1E88E5); // Blue
      case IconCategory.entertainment:
        return const Color(0xFF8BC34A); // Light Green
      case IconCategory.food:
        return const Color(0xFF5D4037); // Brown
      case IconCategory.miscellaneous:
        return const Color(0xFFFDD835); // Yellow
      case IconCategory.unknown:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  static IconCategory fromString(String value) {
    return IconCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => IconCategory.unknown,
    );
  }
}

// Simplified enum for all icons with direct parameters for iconData, iconName, and category
enum AppIcons {
  // Essentials (10 icons)
  home(Icons.home, IconCategory.essentials),
  food(FontAwesomeIcons.utensils, IconCategory.essentials),
  shopping(Icons.shopping_cart, IconCategory.essentials),
  transport(FontAwesomeIcons.bus, IconCategory.essentials),
  car(FontAwesomeIcons.car, IconCategory.essentials),
  water(FontAwesomeIcons.droplet, IconCategory.essentials),
  electric(FontAwesomeIcons.bolt, IconCategory.essentials),
  phone(FontAwesomeIcons.phone, IconCategory.essentials),
  mobile(FontAwesomeIcons.mobileScreenButton, IconCategory.essentials),
  baby(FontAwesomeIcons.baby, IconCategory.essentials),

  // Work (8 icons)
  laptop(FontAwesomeIcons.laptop, IconCategory.work),
  code(FontAwesomeIcons.code, IconCategory.work),
  pen(FontAwesomeIcons.pen, IconCategory.work),
  clipboard(FontAwesomeIcons.clipboard, IconCategory.work),
  book(FontAwesomeIcons.book, IconCategory.work),
  briefcase(FontAwesomeIcons.briefcase, IconCategory.work),
  calculator(FontAwesomeIcons.calculator, IconCategory.work),
  desktop(FontAwesomeIcons.desktop, IconCategory.work),

  // Health (8 icons)
  heart(FontAwesomeIcons.heart, IconCategory.health),
  medical(FontAwesomeIcons.userDoctor, IconCategory.health),
  pills(FontAwesomeIcons.pills, IconCategory.health),
  dumbbell(FontAwesomeIcons.dumbbell, IconCategory.health),
  stethoscope(FontAwesomeIcons.stethoscope, IconCategory.health),
  tooth(FontAwesomeIcons.tooth, IconCategory.health),
  hospital(FontAwesomeIcons.hospitalUser, IconCategory.health),
  thermometer(FontAwesomeIcons.thermometer, IconCategory.health),

  // Travel (8 icons)
  plane(FontAwesomeIcons.plane, IconCategory.travel),
  train(FontAwesomeIcons.train, IconCategory.travel),
  truck(FontAwesomeIcons.truck, IconCategory.travel),
  bicycle(FontAwesomeIcons.bicycle, IconCategory.travel),
  taxi(FontAwesomeIcons.taxi, IconCategory.travel),
  ship(FontAwesomeIcons.ship, IconCategory.travel),
  subway(FontAwesomeIcons.trainSubway, IconCategory.travel),
  motorcycle(FontAwesomeIcons.motorcycle, IconCategory.travel),

  // Entertainment (8 icons)
  music(FontAwesomeIcons.music, IconCategory.entertainment),
  camera(FontAwesomeIcons.camera, IconCategory.entertainment),
  tv(FontAwesomeIcons.tv, IconCategory.entertainment),
  film(FontAwesomeIcons.film, IconCategory.entertainment),
  guitar(FontAwesomeIcons.guitar, IconCategory.entertainment),
  palette(FontAwesomeIcons.palette, IconCategory.entertainment),
  gamepad(FontAwesomeIcons.gamepad, IconCategory.entertainment),
  theater(FontAwesomeIcons.theaterMasks, IconCategory.entertainment),

  // Food (8 icons)
  coffee(FontAwesomeIcons.mugSaucer, IconCategory.food),
  pizza(FontAwesomeIcons.pizzaSlice, IconCategory.food),
  hamburger(FontAwesomeIcons.burger, IconCategory.food),
  apple(FontAwesomeIcons.apple, IconCategory.food),
  wine(FontAwesomeIcons.wineGlass, IconCategory.food),
  icecream(FontAwesomeIcons.iceCream, IconCategory.food),
  restaurant(FontAwesomeIcons.store, IconCategory.food),
  cake(FontAwesomeIcons.cakeCandles, IconCategory.food);

  const AppIcons(this.iconData, this.category);

  final IconData iconData;
  final IconCategory category;

  // Get icon name from enum name
  String get iconName => name;

  // Get display name from enum name (capitalize first letter)
  String get displayName => name[0].toUpperCase() + name.substring(1);

  // Get default color from category
  Color get defaultColor => category.defaultColor;

  // Create IconModel from enum
  IconModel toIconModel([Color? customColor]) {
    return IconModel(
      iconName: iconName,
      color: customColor ?? defaultColor,
      category: category,
    );
  }

  // Get all icons by category
  static List<AppIcons> getByCategory(IconCategory category) {
    return AppIcons.values.where((icon) => icon.category == category).toList();
  }

  // Find icon by name
  static AppIcons? findByName(String name) {
    try {
      return AppIcons.values.firstWhere(
        (icon) => icon.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Get all icon names as a list
  static List<String> getAllIconNames() {
    return AppIcons.values.map((icon) => icon.name).toList();
  }

  static AppIcons getRandomFromCategory(IconCategory category) {
    final icons = getByCategory(category);
    if (icons.isEmpty) return AppIcons.heart; // fallback
    final random = DateTime.now().millisecondsSinceEpoch % icons.length;
    return icons[random];
  }
}

class IconModel {
  final String iconName;
  final Color color;
  final IconCategory category;

  const IconModel({
    required this.iconName,
    required this.color,
    required this.category,
  });

  factory IconModel.withCategory({
    required String iconName,
    required IconCategory category,
    Color? color,
  }) {
    return IconModel(
      iconName: iconName,
      color: color ?? category.defaultColor,
      category: category,
    );
  }

  IconData get data => _getIconData(iconName);
  String get name => iconName;
  String get displayName => _getDisplayName(iconName);

  static IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      // Essential icons
      case 'home':
      case 'house':
        return Icons.home;
      case 'food':
      case 'eating':
        return FontAwesomeIcons.utensils;
      case 'shopping':
      case 'cart':
        return Icons.shopping_cart;
      case 'transport':
      case 'bus':
        return FontAwesomeIcons.bus;
      case 'car':
        return FontAwesomeIcons.car;
      case 'entertainment':
      case 'game':
        return FontAwesomeIcons.gamepad;
      case 'sport':
      case 'gym':
        return Icons.sports_gymnastics_rounded;
      case 'gift':
        return FontAwesomeIcons.gift;
      case 'water':
        return FontAwesomeIcons.droplet;
      case 'electric':
      case 'bolt':
        return FontAwesomeIcons.bolt;
      case 'phone':
        return FontAwesomeIcons.phone;
      case 'mobile':
        return FontAwesomeIcons.mobileScreenButton;
      case 'baby':
        return FontAwesomeIcons.baby;

      // Work icons
      case 'laptop':
        return FontAwesomeIcons.laptop;
      case 'code':
        return FontAwesomeIcons.code;
      case 'pen':
        return FontAwesomeIcons.pen;
      case 'clipboard':
        return FontAwesomeIcons.clipboard;
      case 'book':
        return FontAwesomeIcons.book;
      case 'briefcase':
        return FontAwesomeIcons.briefcase;
      case 'calculator':
        return FontAwesomeIcons.calculator;
      case 'desktop':
        return FontAwesomeIcons.desktop;

      // Health icons
      case 'heart':
        return FontAwesomeIcons.heart;
      case 'medical':
      case 'doctor':
        return FontAwesomeIcons.userDoctor;
      case 'pills':
      case 'medicine':
        return FontAwesomeIcons.pills;
      case 'dumbbell':
      case 'workout':
        return FontAwesomeIcons.dumbbell;
      case 'stethoscope':
        return FontAwesomeIcons.stethoscope;
      case 'tooth':
        return FontAwesomeIcons.tooth;
      case 'hospital':
        return FontAwesomeIcons.hospitalUser;
      case 'thermometer':
        return FontAwesomeIcons.thermometer;

      // Travel icons
      case 'plane':
      case 'flight':
        return FontAwesomeIcons.plane;
      case 'train':
        return FontAwesomeIcons.train;
      case 'truck':
        return FontAwesomeIcons.truck;
      case 'bicycle':
      case 'bike':
        return FontAwesomeIcons.bicycle;
      case 'taxi':
        return FontAwesomeIcons.taxi;
      case 'ship':
        return FontAwesomeIcons.ship;
      case 'subway':
        return FontAwesomeIcons.trainSubway;
      case 'motorcycle':
        return FontAwesomeIcons.motorcycle;

      // Entertainment icons
      case 'music':
        return FontAwesomeIcons.music;
      case 'camera':
        return FontAwesomeIcons.camera;
      case 'tv':
        return FontAwesomeIcons.tv;
      case 'film':
      case 'movie':
        return FontAwesomeIcons.film;
      case 'guitar':
        return FontAwesomeIcons.guitar;
      case 'palette':
      case 'art':
        return FontAwesomeIcons.palette;
      case 'gamepad':
        return FontAwesomeIcons.gamepad;
      case 'theater':
        return FontAwesomeIcons.theaterMasks;

      // Food icons
      case 'coffee':
        return FontAwesomeIcons.mugSaucer;
      case 'pizza':
        return FontAwesomeIcons.pizzaSlice;
      case 'hamburger':
      case 'burger':
        return FontAwesomeIcons.burger;
      case 'apple':
        return FontAwesomeIcons.apple;
      case 'wine':
        return FontAwesomeIcons.wineGlass;
      case 'icecream':
        return FontAwesomeIcons.iceCream;
      case 'restaurant':
        return FontAwesomeIcons.store;
      case 'cake':
        return FontAwesomeIcons.cakeCandles;

      // Default
      default:
        return Icons.question_mark;
    }
  }

  static String _getDisplayName(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'home':
      case 'house':
        return 'Home';
      case 'food':
      case 'eating':
        return 'Food';
      case 'shopping':
      case 'cart':
        return 'Shopping';
      case 'transport':
      case 'bus':
        return 'Transport';
      case 'car':
        return 'Car';
      case 'entertainment':
      case 'game':
        return 'Entertainment';
      case 'sport':
      case 'gym':
        return 'Sport';
      case 'gift':
        return 'Gift';
      case 'water':
        return 'Water';
      case 'electric':
      case 'bolt':
        return 'Electric';
      case 'phone':
        return 'Phone';
      case 'mobile':
        return 'Mobile';
      case 'baby':
        return 'Baby';
      case 'laptop':
        return 'Laptop';
      case 'code':
        return 'Code';
      case 'pen':
        return 'Pen';
      case 'clipboard':
        return 'Clipboard';
      case 'book':
        return 'Book';
      case 'briefcase':
        return 'Briefcase';
      case 'calculator':
        return 'Calculator';
      case 'desktop':
        return 'Desktop';
      case 'heart':
        return 'Heart';
      case 'medical':
      case 'doctor':
        return 'Medical';
      case 'pills':
      case 'medicine':
        return 'Medicine';
      case 'dumbbell':
      case 'workout':
        return 'Workout';
      case 'stethoscope':
        return 'Stethoscope';
      case 'tooth':
        return 'Dental';
      case 'hospital':
        return 'Hospital';
      case 'thermometer':
        return 'Thermometer';
      case 'plane':
      case 'flight':
        return 'Flight';
      case 'train':
        return 'Train';
      case 'truck':
        return 'Truck';
      case 'bicycle':
      case 'bike':
        return 'Bicycle';
      case 'taxi':
        return 'Taxi';
      case 'ship':
        return 'Ship';
      case 'subway':
        return 'Subway';
      case 'motorcycle':
        return 'Motorcycle';
      case 'music':
        return 'Music';
      case 'camera':
        return 'Camera';
      case 'tv':
        return 'TV';
      case 'film':
      case 'movie':
        return 'Movie';
      case 'guitar':
        return 'Guitar';
      case 'palette':
      case 'art':
        return 'Art';
      case 'coffee':
        return 'Coffee';
      case 'pizza':
        return 'Pizza';
      case 'hamburger':
      case 'burger':
        return 'Burger';
      case 'apple':
        return 'Apple';
      case 'wine':
        return 'Wine';
      case 'icecream':
        return 'Ice Cream';
      case 'restaurant':
        return 'Restaurant';
      case 'cake':
        return 'Cake';
      default:
        return iconName
            .split('_')
            .map((word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1)
                : '')
            .join(' ');
    }
  }

  // Helper method to create icon with custom color
  IconModel copyWith({
    String? iconName,
    Color? color,
    IconCategory? category,
  }) {
    return IconModel(
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IconModel &&
        other.iconName == iconName &&
        other.color == color &&
        other.category == category;
  }

  @override
  int get hashCode => iconName.hashCode ^ color.hashCode ^ category.hashCode;

  @override
  String toString() =>
      'IconModel(iconName: $iconName, color: $color, category: $category)';
}
