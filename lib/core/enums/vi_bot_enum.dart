import 'dart:convert';

import 'package:budget_app/core/extension/extension_package_info.dart';
import 'package:budget_app/view/base_controller/pakage_info_base_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ViBotProcessStep {
  intentExtraction,
  disambiguation,
  actionExecution;
}

enum ViBotEnum {
  askCommon,
  askAppAndContact,
  newBudget,
  newTransaction,
  askBudget,
  askTransaction;

  factory ViBotEnum.fromValue(String value) {
    return ViBotEnum.values.firstWhereOrNull((e) => e.name == value) ??
        ViBotEnum.askCommon;
  }

  factory ViBotEnum.fromViBot(String response) {
    // Extract type from response format: [TYPE:action_type]
    final typeMatch = RegExp(r'\[TYPE:(\w+)\]').firstMatch(response);
    if (typeMatch != null) {
      final typeString = typeMatch.group(1);
      switch (typeString) {
        case 'newBudget':
          return ViBotEnum.newBudget;
        case 'newTransaction':
          return ViBotEnum.newTransaction;
        case 'askBudget':
          return ViBotEnum.askBudget;
        case 'askTransaction':
          return ViBotEnum.askTransaction;
        case 'askAppAndContact':
          return ViBotEnum.askAppAndContact;
        case 'askCommon':
          return ViBotEnum.askCommon;
      }
    }
    return ViBotEnum.askCommon;
  }
}

class ViBotIntentData {
  final ViBotEnum intent;
  final Map<String, dynamic> extractedEntities;
  final List<String> missingFields;
  final List<String> ambiguousFields;
  final bool needsDisambiguation;
  final String originalMessage;

  const ViBotIntentData({
    required this.intent,
    required this.extractedEntities,
    required this.missingFields,
    required this.ambiguousFields,
    required this.needsDisambiguation,
    required this.originalMessage,
  });

  factory ViBotIntentData.fromAIResponse(
      String aiResponse, String originalMessage) {
    // Parse AI response to extract intent and entities
    final intentMatch = RegExp(r'\[INTENT:(\w+)\]').firstMatch(aiResponse);
    final entitiesMatch =
        RegExp(r'\[ENTITIES:(.*?)\]', dotAll: true).firstMatch(aiResponse);
    final missingMatch =
        RegExp(r'\[MISSING:(.*?)\]', dotAll: true).firstMatch(aiResponse);
    final ambiguousMatch =
        RegExp(r'\[AMBIGUOUS:(.*?)\]', dotAll: true).firstMatch(aiResponse);

    final intent = intentMatch != null
        ? ViBotEnum.fromValue(intentMatch.group(1)!)
        : ViBotEnum.askCommon;

    Map<String, dynamic> entities = {};
    if (entitiesMatch != null) {
      try {
        entities = jsonDecode(entitiesMatch.group(1)!) as Map<String, dynamic>;
      } catch (e) {
        // If JSON parsing fails, keep empty entities
      }
    }

    final missingFields =
        missingMatch?.group(1)?.split(',').map((e) => e.trim()).toList() ?? [];
    final ambiguousFields =
        ambiguousMatch?.group(1)?.split(',').map((e) => e.trim()).toList() ??
            [];

    return ViBotIntentData(
      intent: intent,
      extractedEntities: entities,
      missingFields: missingFields,
      ambiguousFields: ambiguousFields,
      needsDisambiguation:
          missingFields.isNotEmpty || ambiguousFields.isNotEmpty,
      originalMessage: originalMessage,
    );
  }
}

extension ConvertViBotEnum on ViBotEnum {
  String toDataBot(WidgetRef ref) {
    switch (this) {
      case ViBotEnum.askCommon:
        return """
General conversation and questions about personal finance, budgeting tips, or general app usage.
If the user asks about features handled by other intents (e.g., newBudget, newTransaction), reply with what information you need to complete the request. If irrelevant, you may ignore.
Examples: "How can I save money?", "What's a good budgeting strategy?", "Hello", "Thank you"
Response style: Friendly, helpful, conversational
""";
      case ViBotEnum.askAppAndContact:
        return """
Provide information about the app or contact details.
Current app info:
${ref.read(packageInfoBaseControllerProvider).toChatData}
Examples: "How do I contact support?", "What version is this app?", "How do I export data?"
Response style: Professional, informative, include relevant app details
""";
      case ViBotEnum.newBudget:
        return """
Create a new budget. Extract necessary info from the user's message and ask for missing info if needed.
Requirements for budget creation:
- Budget name: Extract and format nicely (e.g., "uống cafe" → "Uống cafe")
- Icon category: Determine by category (food, transportation, entertainment, essentials, work, health, travel, miscellaneous)
- Budget type: income or expense (inferred from budgetName or user intent)
- Budget limit: Default 0 or user-provided
- Date range: allTime, week, month, year, custom
- Start/End dates based on range type

Examples: 
- "Create a food budget" → Food budget, expense type, month range
- "Set up an entertainment budget with 500k limit" → Entertainment budget, 500,000 VND limit
- "I need a transportation budget for this year" → Transportation budget, year range
""";
      case ViBotEnum.newTransaction:
        return """
Create a new transaction. Extract info from the user's message and ask for missing info if needed.
Use existing budgetId, or ask the user to create/select a budget first.
Requirements:
- Amount: Required, extract from user message
- Budget: Match to existing budget or ask user to create one
- Note: User-provided or default "createByViBot"
- Transaction type: income (if user adds money), expense (if user spends money)
- Date: Default to now unless specified

Examples:
- "I spent 50k on lunch" → 50,000 VND expense for Food budget
- "Coffee 30k yesterday" → 30,000 VND expense, yesterday's date
- "Received 2M salary" → 2,000,000 VND income for Salary budget
""";
      case ViBotEnum.askBudget:
        return """
Answer questions about budgets using the provided budget data.
Optionally, filter/query to reduce context and make analysis easier.
Available data: Budget names, amounts, limits, date ranges, status (active/expired/coming)

Examples:
- "ngân sách tháng 7" / "July budget"
- "ngân sách nào thu nhập nhiều nhất" / "which budget has most income"
- "Show my budget summary" → Display all budgets with current amounts
- "How much have I spent on food?" → Food budget analysis
- "What's my budget status?" → Overall budget overview

Response: Provide specific budget information, spending insights, and actionable advice
""";
      case ViBotEnum.askTransaction:
        return """
Answer questions about transactions using the provided budget and transaction data.
Optionally, filter/query for easier analysis.
Available data: Transaction amounts, dates, notes, budget categories, trends

Examples:
- "lần cuối giao dịch khi nào" / "when was last transaction"
- "tháng này có giao dịch gì" / "what transactions this month"
- "Show my recent transactions" → Recent transaction list
- "How much did I spend this month?" → Monthly spending analysis
- "What did I spend on yesterday?" → Daily transaction summary

Response: Provide transaction insights, spending patterns, and financial analysis
""";
    }
  }
}
