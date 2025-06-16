import 'package:budget_app/data/models/models_widget/icon_model.dart';
import 'package:flutter/material.dart';

class IconManagerData {
  const IconManagerData._();

  static const IconModel _defaultIcon = IconModel(
    iconName: 'unknown',
    color: Color(0xFF9E9E9E),
    category: IconCategory.unknown,
  );

  // Get all available icons using the new enum system
  static List<IconModel> listIconSelect() {
    return AppIcons.values.map((icon) => icon.toIconModel()).toList();
  }

  // Get icon model by name using the enum system
  static IconModel getIconModel(String iconName) {
    final appIcon = AppIcons.findByName(iconName);
    return appIcon?.toIconModel() ?? _defaultIcon;
  }

  // Get icons by category using the enum system
  static List<IconModel> getIconsByCategory(IconCategory category) {
    return AppIcons.getByCategory(category)
        .map((icon) => icon.toIconModel())
        .toList();
  }

  // Get random icon from category
  static IconModel getIconByCategory(IconCategory category) {
    final appIcon = AppIcons.getRandomFromCategory(category);
    return appIcon.toIconModel();
  }

  // Get all available categories
  static List<IconCategory> getAllCategories() {
    return IconCategory.values
        .where((cat) => cat != IconCategory.unknown)
        .toList();
  }

  // Create custom icon with specific properties
  static IconModel createCustomIcon({
    required String iconName,
    required IconCategory category,
    Color? customColor,
  }) {
    final appIcon = AppIcons.findByName(iconName);
    if (appIcon != null) {
      return appIcon.toIconModel(customColor);
    }

    return IconModel(
      iconName: iconName,
      color: customColor ?? category.defaultColor,
      category: category,
    );
  }

  // Category-specific getters using enum system
  static List<IconModel> getEssentialIcons() =>
      getIconsByCategory(IconCategory.essentials);

  static List<IconModel> getWorkIcons() =>
      getIconsByCategory(IconCategory.work);

  static List<IconModel> getHealthIcons() =>
      getIconsByCategory(IconCategory.health);

  static List<IconModel> getTravelIcons() =>
      getIconsByCategory(IconCategory.travel);

  static List<IconModel> getEntertainmentIcons() =>
      getIconsByCategory(IconCategory.entertainment);

  static List<IconModel> getFoodIcons() =>
      getIconsByCategory(IconCategory.food);

  // Get all icon names from enum
  static List<String> getIconNamesForCategory(IconCategory category) {
    return AppIcons.getByCategory(category)
        .map((icon) => icon.iconName)
        .toList();
  }

  // Get all available icon names
  static List<String> getAllIconNames() {
    return AppIcons.getAllIconNames();
  }

  // Search icons by name or display name
  static List<IconModel> searchIcons(String query) {
    if (query.isEmpty) return listIconSelect();

    final lowerQuery = query.toLowerCase();
    return AppIcons.values
        .where((icon) =>
            icon.iconName.toLowerCase().contains(lowerQuery) ||
            icon.displayName.toLowerCase().contains(lowerQuery))
        .map((icon) => icon.toIconModel())
        .toList();
  }

  // Get icon statistics
  static Map<IconCategory, int> getIconCategoryStats() {
    final stats = <IconCategory, int>{};
    for (final category in IconCategory.values) {
      if (category != IconCategory.unknown) {
        stats[category] = AppIcons.getByCategory(category).length;
      }
    }
    return stats;
  }

  // Get total icon count
  static int getTotalIconCount() => AppIcons.values.length;

  // Get most used category (you can extend this with usage tracking)
  static IconCategory getMostPopularCategory() {
    return IconCategory.essentials; // Default, can be dynamic based on usage
  }

  // Validate if icon exists
  static bool iconExists(String iconName) {
    return AppIcons.findByName(iconName) != null;
  }

  // Get suggested icons based on category
  static List<IconModel> getSuggestedIcons(IconCategory category,
      {int limit = 5}) {
    final icons = getIconsByCategory(category);
    if (icons.length <= limit) return icons;

    // Return first 'limit' icons, you can implement more sophisticated logic
    return icons.take(limit).toList();
  }
}
