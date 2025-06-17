import 'dart:convert';

import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/icon_manager_data.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/data/models/models_widget/icon_model.dart';
import 'package:budget_app/data/services/vi_bot_service.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/view/base_controller/chat_base_controller.dart';
import 'package:budget_app/view/base_controller/pakage_info_base_controller.dart';
import 'package:budget_app/core/enums/role_chat_enum.dart';
import 'package:budget_app/core/enums/vi_bot_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/chat_content_model.dart';
import 'package:budget_app/data/datasources/repositories/budget_repository.dart';
import 'package:budget_app/data/datasources/repositories/transaction_repository.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/remote_config_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/data/models/chat_model.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

final chatAPIProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  final uid = ref.watch(uidControllerProvider);
  return ChatApi(db: db, uid: uid, ref: ref);
});

abstract class IBotApi {}

class ChatApi implements IBotApi {
  final FirebaseFirestore db;
  final String _uid;
  final Ref _ref;

  ChatApi({
    required this.db,
    required String uid,
    required Ref ref,
  })  : _uid = uid,
        _ref = ref;

  List<ChatContentModel> basePrompt(BuildContext context) {
    final userModel = _ref.read(userBaseControllerProvider);
    final budgets = _ref.read(budgetBaseControllerProvider);
    final loc = AppLocalizations.of(context);

    List<ChatContentModel> baseContents = [
      ChatContentModel(
          role: RoleChatEnum.user, content: """${loc.viBotPersonality}
Your personality:
- ${loc.viBotPersonalityTraits}

Key capabilities:
1. ${loc.viBotCapabilities}

Current user info:
${userModel.toChatData}

Available budgets: ${budgets.toChatData()}

${loc.viBotTransactionRules}

IMPORTANT RESPONSE FORMAT:
You must always include a response type indicator at the beginning of your response using this format:
[TYPE:action_type] followed by your response

Available action types:
- askCommon: General conversation, questions, or information requests
- askAppAndContact: Questions about app features, contact information, or technical support
- newBudget: Creating a new budget only (no transaction)
- newTransaction: Creating a transaction for existing budget
- askBudget: Questions about existing budgets, budget status, or budget information
- askTransaction: Questions about transactions, transaction history, or transaction analysis

For budget creation, include details in this JSON format after your response:
{
  "budgetName": "short and clear name",
  "iconCategory": "food|transportation|entertainment|essentials|work|health|travel|miscellaneous",
  "budgetType": "income|expense",
  "budgetLimit": amount_or_0,
  "rangeDateTimeType": "allTime|week|month|year|custom",
  "startDate": "YYYY-MM-DD or 'now'",
  "endDate": "YYYY-MM-DD or '9999-12-31'",
  "amount": transaction_amount_if_creating_transaction
}

Examples:
User: "Create a food budget for this month"
You: "[TYPE:newBudget] I'll help you create a food budget for this month! 
{
  "budgetName": "Food",
  "iconCategory": "food",
  "budgetType": "expense",
  "budgetLimit": 0,
  "rangeDateTimeType": "month",
  "startDate": "now",
  "endDate": "2024-12-31",
  "amount": 0
}"

User: "I spent 50k on lunch today"
You: "[TYPE:newTransaction] Got it! I've recorded your lunch expense of 50,000 VND."

User: "Create an entertainment budget and add 100k for movies"
You: "[TYPE:newBudgetAndTransaction] Perfect! I've created an entertainment budget and added your 100,000 VND movie expense.
{
  "budgetName": "Entertainment",
  "iconCategory": "entertainment", 
  "budgetType": "expense",
  "budgetLimit": 0,
  "rangeDateTimeType": "month",
  "startDate": "now",
  "endDate": "2024-12-31",
  "amount": 100000
}"

${loc.viBotResponseFormat}

${loc.viBotClosing}"""),
    ];
    return baseContents;
  }

  FutureEither<ChatModel> sendMessage(BuildContext context,
      {required List<ChatModel> history}) async {
    AppLocalizations loc = AppLocalizations.of(context);
    DateTime now = DateTime.now();
    final currentUserChat = history.last;
    final remoteConfig = _ref.read(remoteConfigBaseControllerProvider);
    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${remoteConfig.assistantApiKey}',
    };

    history.sort((a, b) => a.createdDate.compareTo(b.createdDate));
    List<ChatContentModel> messages = history
        .map((e) => ChatContentModel(
              role: RoleChatEnum.fromValue(e.roleTypeValue),
              content: e.message,
            ))
        .toList();

    messages.insertAll(messages.length - 1, basePrompt(context));

    final body = jsonEncode({
      "model": remoteConfig.assistantModel,
      "messages": messages.toMapList(),
      "temperature": 0.7,
      "max_tokens": 500,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices']?[0]?['message']?['content'] ?? '';
        if (reply.isEmpty) {
          return left(Failure(message: loc.errorContactSupport));
        }
        if (!context.mounted) {
          throw Exception('Context is not mounted');
        }

        ChatModel assistentChat = ChatModel(
          id: GenId.chat,
          userId: _uid,
          message: reply,
          roleTypeValue: RoleChatEnum.assistant.value,
          createdDate: now,
          updatedDate: now,
        );

        // Process the AI response for actions before writing to DB
        _processAIResponse(reply, context);

        // Write to DB
        List<ChatModel> list = [currentUserChat, assistentChat];
        bool writeSuccess = await _writeToDB(list);
        if (!writeSuccess) {
          return left(Failure(message: loc.errorContactSupport));
        }
        return right(assistentChat);
      } else {
        throw Exception(
            'Failed to send message: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      logError('ChatApi sendMessage error: $e');
      return left(Failure(message: loc.errorContactSupport));
    }
  }

  /// Enhanced 3-step AI-driven workflow implementation
  FutureEither<ChatModel> sendMessageWithThreeStepFlow(BuildContext context,
      {required List<ChatModel> history}) async {
    AppLocalizations loc = AppLocalizations.of(context);
    DateTime now = DateTime.now();
    final currentUserChat = history.last;
    final userMessage = currentUserChat.message;

    try {
      // STEP 1: User Request Analysis - Let AI analyze and extract intent/entities
      final analysisResponse = await _callAI(
          context,
          _buildRequestAnalysisPrompt(context, userMessage),
          'Request Analysis');

      if (analysisResponse.isLeft()) {
        return left(analysisResponse.getLeftOrDefault());
      }

      final analysisResult = analysisResponse.getRight().getOrElse(() => '');
      final intentData =
          ViBotIntentData.fromAIResponse(analysisResult, userMessage);

      // STEP 2: Smart Data Preparation - AI gets app context and processes it
      final contextResponse = await _callAI(context,
          _buildContextAnalysisPrompt(context, intentData), 'Context Analysis');

      if (contextResponse.isLeft()) {
        return left(contextResponse.getLeftOrDefault());
      }

      final contextAnalysis = contextResponse.getRight().getOrElse(() => '');
      final actionPlan = _extractActionPlan(contextAnalysis);

      // STEP 3: Intelligent Action Execution - AI formats and executes the plan
      ChatModel finalResponse;

      if (actionPlan.needsClarification) {
        // AI determined more info is needed
        finalResponse = ChatModel(
          id: GenId.chat,
          userId: _uid,
          message: actionPlan.clarificationMessage,
          roleTypeValue: RoleChatEnum.assistant.value,
          createdDate: now,
          updatedDate: now,
        );
      } else {
        // AI has all info needed, execute the action
        final executionResult =
            await _executeAIPlannedAction(actionPlan, context);

        finalResponse = ChatModel(
          id: GenId.chat,
          userId: _uid,
          message: executionResult.successMessage,
          roleTypeValue: RoleChatEnum.assistant.value,
          createdDate: now,
          updatedDate: now,
        );
      }

      // Write to database
      List<ChatModel> list = [currentUserChat, finalResponse];
      bool writeSuccess = await _writeToDB(list);
      if (!writeSuccess) {
        return left(Failure(message: loc.errorContactSupport));
      }

      return right(finalResponse);
    } catch (e) {
      logError('ChatApi sendMessageWithThreeStepFlow error: $e');
      return left(Failure(message: loc.errorContactSupport));
    }
  }

  /// Helper method to call AI with specific prompts
  Future<Either<Failure, String>> _callAI(BuildContext context,
      List<ChatContentModel> messages, String stepName) async {
    final remoteConfig = _ref.read(remoteConfigBaseControllerProvider);
    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${remoteConfig.assistantApiKey}',
    };

    final body = jsonEncode({
      "model": remoteConfig.assistantModel,
      "messages": messages.toMapList(),
      "temperature": 0.3,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices']?[0]?['message']?['content'] ?? '';
        if (reply.isEmpty) {
          return left(Failure(message: 'Empty response from AI'));
        }
        return right(reply);
      } else {
        throw Exception(
            'Failed $stepName: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      logError('AI call error in $stepName: $e');
      return left(Failure(message: 'AI processing failed'));
    }
  }

 
  void _processAIResponse(String reply, BuildContext context) async {
    // Implement the processing of AI response for actions
    // This could include updating budgets, creating transactions, etc.
    // Based on the new AI response structure and intent system

    final intentData = ViBotIntentData.fromAIResponse(reply, '');

    switch (intentData.intent) {
      case ViBotEnum.newBudget:
        // Extract budget details and create budget
        final budgetData = _extractBudgetData(reply);
        if (budgetData != null) {
          await _handleNewBudget(budgetData, context);
        }
        break;
      case ViBotEnum.newTransaction:
        // Extract transaction details and create transaction
        final transactionData = _extractTransactionData(reply);
        if (transactionData != null) {
          await _handleNewTransaction(transactionData, context);
        }
        break;
      case ViBotEnum.askBudget:
        // Handle budget inquiry, possibly generate a summary
        await _handleBudgetInquiry(reply, context);
        break;
      case ViBotEnum.askTransaction:
        // Handle transaction inquiry, provide analysis or details
        await _handleTransactionInquiry(reply, context);
        break;
      case ViBotEnum.askAppAndContact:
        // Provide app information or contact support details
        await _handleAppAndContactInquiry(reply, context);
        break;
      case ViBotEnum.askCommon:
        // General questions, no specific action required
        break;
    }
  }

  Map<String, dynamic>? _extractBudgetData(String response) {
    // Extract JSON data from response
    final jsonMatch = RegExp(r'\{[\s\S]*?\}').firstMatch(response);
    if (jsonMatch != null) {
      try {
        return jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
      } catch (e) {
        logError('Error parsing budget JSON: $e');
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic>? _extractTransactionData(String response) {
    // Extract transaction data from AI response
    // This will depend on how the transaction data is structured in the response
    final jsonMatch = RegExp(r'\{[\s\S]*?\}').firstMatch(response);
    if (jsonMatch != null) {
      try {
        return jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
      } catch (e) {
        logError('Error parsing transaction JSON: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> _handleNewBudget(
      Map<String, dynamic> budgetData, BuildContext context) async {
    try {
      final budgetRepository = _ref.read(budgetRepositoryProvider);
      final budgetController = _ref.read(budgetBaseControllerProvider.notifier);

      final budgetName = budgetData['budgetName'] as String? ?? 'New Budget';
      final iconCategoryStr =
          budgetData['iconCategory'] as String? ?? 'miscellaneous';
      final budgetTypeStr = budgetData['budgetType'] as String? ?? 'expense';
      final budgetLimit = budgetData['budgetLimit'] as int? ?? 0;
      final rangeDateTimeTypeStr =
          budgetData['rangeDateTimeType'] as String? ?? 'month';
      final startDateStr = budgetData['startDate'] as String? ?? 'now';
      final endDateStr = budgetData['endDate'] as String? ?? '9999-12-31';

      // Parse icon category
      final iconCategory = IconCategory.fromString(iconCategoryStr);

      // Parse budget type
      final budgetType = budgetTypeStr == 'income'
          ? BudgetTypeEnum.income
          : BudgetTypeEnum.expense;

      // Parse range date time type
      final rangeDateTimeType = _parseRangeDateTimeType(rangeDateTimeTypeStr);

      // Parse dates
      final now = DateTime.now();
      final startDate = _parseDate(startDateStr, now);
      final endDate = _parseDate(endDateStr, DateTime(9999, 12, 31));

      final newBudget = BudgetModel(
        id: GenId.budget(),
        userId: _uid,
        name: budgetName,
        iconName: IconManagerData.getIconByCategory(iconCategory).name,
        currentAmount: 0,
        budgetLimit: budgetLimit,
        budgetTypeValue: budgetType.value,
        rangeDateTimeTypeValue: rangeDateTimeType.value,
        startDate: startDate,
        endDate: endDate,
        createdDate: now,
        updatedDate: now,
      );

      final result = await budgetRepository.addBudget(model: newBudget);
      result.fold(
        (failure) => logError('Failed to create budget: ${failure.message}'),
        (_) => budgetController.addBudgetState(newBudget),
      );
    } catch (e) {
      logError('Error creating budget: $e');
    }
  }

  Future<void> _handleNewTransaction(
      Map<String, dynamic> transactionData, BuildContext context) async {
    try {
      final userMessage = transactionData['userMessage'] as String? ?? '';
      final availableBudgets =
          transactionData['availableBudgets'] as List<BudgetModel>? ?? [];
      final user = transactionData['user'] as UserModel?;

      if (user == null || availableBudgets.isEmpty) {
        logError('Missing user or budgets for transaction creation');
        return;
      }

      // Use ViBotService to extract transaction details from user message
      final amount = ViBotService.extractAmount(userMessage);
      if (amount == null) {
        logError('Could not extract amount from message: $userMessage');
        return;
      }

      final matchingBudget =
          ViBotService.findMatchingBudget(userMessage, availableBudgets);
      if (matchingBudget == null) {
        logError('No matching budget found for message: $userMessage');
        return;
      }

      final transactionDate =
          ViBotService.extractDate(userMessage) ?? DateTime.now();
      final note = ViBotService.extractNote(userMessage);
      final finalNote =
          note.isEmpty ? AppLocalizations.of(context).createdByViBot : note;

      // Create transaction
      final transactionRepository = _ref.read(transactionRepositoryProvider);
      final result = await transactionRepository.addBudgetTransaction(
        user: user,
        budgetModel: matchingBudget,
        amount: amount,
        note: finalNote,
        transactionDate: transactionDate,
      );

      result.fold(
        (failure) =>
            logError('Failed to create transaction: ${failure.message}'),
        (success) {
          final (transaction, updatedBudget, updatedUser) = success;
          // Update states
          _ref.read(userBaseControllerProvider.notifier).reload(updatedUser);
          _ref
              .read(budgetBaseControllerProvider.notifier)
              .updateState(updatedBudget);
          _ref
              .read(transactionsBaseControllerProvider.notifier)
              .addState(transaction);
        },
      );
    } catch (e) {
      logError('Error creating transaction: $e');
    }
  }

  Future<void> _handleBudgetInquiry(
      String aiResponse, BuildContext context) async {
    try {
      final budgets = _ref.read(budgetBaseControllerProvider);
      final transactions = _ref
          .read(transactionsBaseControllerProvider)
          .map((e) => e.transaction)
          .toList();
      final user = _ref.read(userBaseControllerProvider);

      // Generate budget summary or specific budget analysis
      final locale = user.languageCode;
      final summary = ViBotService.generateBudgetSummary(
        budgets: budgets,
        transactions: transactions,
        user: user,
        locale: locale,
      );

      // Create and send response chat
      final responseChat = ChatModel(
        id: GenId.chat,
        userId: _uid,
        message: summary,
        roleTypeValue: RoleChatEnum.assistant.value,
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      );

      await _writeToDB([responseChat]);
    } catch (e) {
      logError('Error handling budget inquiry: $e');
    }
  }

  Future<void> _handleTransactionInquiry(
      String aiResponse, BuildContext context) async {
    try {
      final transactions = _ref
          .read(transactionsBaseControllerProvider)
          .map((e) => e.transaction)
          .toList();
      final budgets = _ref.read(budgetBaseControllerProvider);
      final user = _ref.read(userBaseControllerProvider);
      final userMessage = _getOriginalUserMessage();

      final locale = user.languageCode;

      // Analyze transactions based on user query
      String response = _generateTransactionAnalysis(
        transactions: transactions,
        budgets: budgets,
        userMessage: userMessage,
        locale: locale,
      );

      // Create and send response chat
      final responseChat = ChatModel(
        id: GenId.chat,
        userId: _uid,
        message: response,
        roleTypeValue: RoleChatEnum.assistant.value,
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      );

      await _writeToDB([responseChat]);
    } catch (e) {
      logError('Error handling transaction inquiry: $e');
    }
  }

  Future<void> _handleAppAndContactInquiry(
      String aiResponse, BuildContext context) async {
    try {
      final packageInfo = _ref.read(packageInfoBaseControllerProvider);
      final remoteConfig = _ref.read(remoteConfigBaseControllerProvider);

      // Generate app and contact information
      String response = _generateAppContactInfo(packageInfo, remoteConfig);

      // Create and send response chat
      final responseChat = ChatModel(
        id: GenId.chat,
        userId: _uid,
        message: response,
        roleTypeValue: RoleChatEnum.assistant.value,
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      );

      await _writeToDB([responseChat]);
    } catch (e) {
      logError('Error handling app and contact inquiry: $e');
    }
  }

  RangeDateTimeEnum _parseRangeDateTimeType(String typeStr) {
    switch (typeStr.toLowerCase()) {
      case 'week':
        return RangeDateTimeEnum.week;
      case 'month':
        return RangeDateTimeEnum.month;
      case 'year':
        return RangeDateTimeEnum.year;
      case 'alltime':
      case 'all_time':
        return RangeDateTimeEnum.allTime;
      default:
        return RangeDateTimeEnum.month;
    }
  }

  DateTime _parseDate(String dateStr, DateTime defaultDate) {
    if (dateStr.toLowerCase() == 'now') {
      return DateTime.now();
    }

    // Try to parse ISO date format YYYY-MM-DD
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      // If parsing fails, return the default date
      return defaultDate;
    }
  }

  String _generateTransactionAnalysis({
    required List<TransactionModel> transactions,
    required List<BudgetModel> budgets,
    required String userMessage,
    required String locale,
  }) {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    final nextMonth = DateTime(now.year, now.month + 1);

    // Filter recent transactions
    final recentTransactions = transactions
        .where((t) =>
            t.transactionDate.isAfter(thisMonth) &&
            t.transactionDate.isBefore(nextMonth))
        .toList();

    if (locale == 'vi') {
      return '''📊 **Phân tích giao dịch**

📝 Giao dịch gần đây: ${recentTransactions.length} giao dịch
💰 Tổng chi tiêu tháng này: ${recentTransactions.where((t) => t.amount < 0).fold(0, (sum, t) => sum + t.amount.abs())}đ
💵 Tổng thu nhập tháng này: ${recentTransactions.where((t) => t.amount > 0).fold(0, (sum, t) => sum + t.amount)}đ

${recentTransactions.isEmpty ? 'Bạn chưa có giao dịch nào tháng này.' : 'Giao dịch gần nhất: ${recentTransactions.last.note} - ${recentTransactions.last.amount}đ'}

Hãy hỏi tôi nếu bạn cần thêm thông tin chi tiết! 😊''';
    } else {
      return '''📊 **Transaction Analysis**

📝 Recent transactions: ${recentTransactions.length} transactions
💰 Total expenses this month: \$${recentTransactions.where((t) => t.amount < 0).fold(0, (sum, t) => sum + t.amount.abs())}
💵 Total income this month: \$${recentTransactions.where((t) => t.amount > 0).fold(0, (sum, t) => sum + t.amount)}

${recentTransactions.isEmpty ? 'You don\'t have any transactions this month.' : 'Latest transaction: ${recentTransactions.last.note} - \$${recentTransactions.last.amount}'}

Feel free to ask if you need more details! 😊''';
    }
  }

  String _generateAppContactInfo(dynamic packageInfo, dynamic remoteConfig) {
    return '''📱 **App Information**

🏷️ App Name: Budget SS
📱 Version: ${packageInfo?.version ?? 'Unknown'}
🔧 Build: ${packageInfo?.buildNumber ?? 'Unknown'}

📞 **Contact Support**
📧 Email: support@budgetapp.com
🌐 Website: https://budgetapp.com
💬 In-app support: Available 24/7

🔒 **Privacy & Security**
All your financial data is encrypted and stored securely. We never share your personal information with third parties.

Need help with a specific feature? Just ask! 😊''';
  }

  List<ChatContentModel> intentExtractionPrompt(
      BuildContext context, String userMessage) {
    final loc = AppLocalizations.of(context);

    return [
      ChatContentModel(
          role: RoleChatEnum.user, content: """${loc.viBotPersonality}

STEP 1: INTENT EXTRACTION AND ENTITY ANALYSIS

Analyze the user's request and provide a structured response in this exact format:

[INTENT:action_type]
[ENTITIES:{"key":"value"}]
[MISSING:field1,field2]
[AMBIGUOUS:field1,field2]

Available intent types:
- newBudget: Creating a new budget
- newTransaction: Adding a transaction to existing budget
- newBudgetAndTransaction: Creating budget + first transaction
- askBudget: Questions about budget status/analysis
- askTransaction: Questions about transaction history/analysis
- askAppAndContact: App info or support questions
- askCommon: General conversation

For each intent, extract these entities:

**newBudget:**
- budgetName: string
- budgetType: "income" or "expense"
- budgetLimit: number (0 if not specified)
- rangeDateTimeType: "week", "month", "year", "allTime"

**newTransaction:**
- amount: number (required)
- budgetName: string (can be partial/category)
- note: string (optional)
- transactionDate: ISO date or relative ("yesterday", "today")

**askBudget/askTransaction:**
- timeframe: "this month", "last week", etc.
- category: specific budget category
- analysisType: "summary", "comparison", "status"

Mark fields as MISSING if required but not provided.
Mark fields as AMBIGUOUS if unclear or could match multiple options.

User request: "$userMessage"
""")
    ];
  }

  List<ChatContentModel> disambiguationPrompt(BuildContext context,
      ViBotIntentData intentData, Map<String, dynamic> appData) {
    final loc = AppLocalizations.of(context);
    final userModel = _ref.read(userBaseControllerProvider);
    final budgets = _ref.read(budgetBaseControllerProvider);

    return [
      ChatContentModel(
          role: RoleChatEnum.user, content: """${loc.viBotPersonality}

STEP 2: DISAMBIGUATION WITH APP DATA

Original user request: "${intentData.originalMessage}"
Detected intent: ${intentData.intent.name}
Extracted entities: ${jsonEncode(intentData.extractedEntities)}
Missing fields: ${intentData.missingFields.join(', ')}
Ambiguous fields: ${intentData.ambiguousFields.join(', ')}

Current user info:
${userModel.toChatData}

Available budgets: ${budgets.toChatData()}

Additional app data:
${jsonEncode(appData)}

Based on the user's intent and available data:

1. Resolve any ambiguous budget names by matching to existing budgets
2. If multiple budgets match, ask user to clarify which one
3. If no matching budget exists for transactions, suggest creating one
4. Fill in any missing required information with reasonable defaults
5. Provide final confirmation of the action to be taken

Respond with either:
- [ACTION:confirmed] + details if ready to execute
- [CLARIFICATION:needed] + specific question for user

Use natural, conversational language in the user's preferred language (${userModel.languageCode}).
""")
    ];
  }

  /// STEP 1: Build enhanced request analysis prompt
  List<ChatContentModel> _buildRequestAnalysisPrompt(
      BuildContext context, String userMessage) {
    final loc = AppLocalizations.of(context);
    final userModel = _ref.read(userBaseControllerProvider);

    return [
      ChatContentModel(
          role: RoleChatEnum.user, content: """${loc.viBotPersonality}

**STEP 1: ADVANCED REQUEST ANALYSIS**

You are an intelligent financial assistant. Analyze the user's request and extract all relevant information.

User's preferred language: ${userModel.languageCode}
Current user balance: ${userModel.balanceMoney}

Analyze this request: "$userMessage"

Provide structured analysis in this format:

[INTENT:action_type]
[ENTITIES:{"key":"value"}]
[CONFIDENCE:high|medium|low]
[LANGUAGE:detected_language]
[MISSING_INFO:field1,field2]
[CONTEXT_NEEDED:budget_data|transaction_data|user_data|none]

Available intents:
- newBudget: Create new budget
- newTransaction: Add transaction to budget  
- newBudgetWithTransaction: Create budget + add first transaction
- askBudget: Budget questions/analysis
- askTransaction: Transaction questions/analysis
- askAppAndContact: App info/support
- askCommon: General conversation

For financial requests, extract:
- amount: numerical value (support k=thousand, m=million, VND, USD formats)
- category: food, transportation, entertainment, health, essentials, work, travel, miscellaneous
- timeframe: today, yesterday, this week, this month, specific date
- budget_name: explicit or inferred budget name
- transaction_type: income, expense
- note: additional context

Be intelligent about:
- Multi-language support (English/Vietnamese)
- Currency formats (50k, 2M, 100,000đ, \$50)
- Date expressions (hôm qua, yesterday, 3 days ago)
- Category inference from context
- Intent disambiguation (create vs query vs update)

Mark CONFIDENCE as:
- high: Clear intent and sufficient data
- medium: Intent clear but some missing data
- low: Ambiguous intent or insufficient data
""")
    ];
  }

  /// STEP 2: Build context analysis prompt with app data
  List<ChatContentModel> _buildContextAnalysisPrompt(
      BuildContext context, ViBotIntentData intentData) {
    final loc = AppLocalizations.of(context);
    final userModel = _ref.read(userBaseControllerProvider);
    final budgets = _ref.read(budgetBaseControllerProvider);
    final transactions = _ref
        .read(transactionsBaseControllerProvider)
        .map((e) => e.transaction)
        .toList();

    return [
      ChatContentModel(
          role: RoleChatEnum.user, content: """${loc.viBotPersonality}

**STEP 2: INTELLIGENT CONTEXT ANALYSIS**

Original request: "${intentData.originalMessage}"
Detected intent: ${intentData.intent.name}
Extracted entities: ${jsonEncode(intentData.extractedEntities)}

**Current App Context:**
User info: ${userModel.toChatData}
Available budgets: ${budgets.toChatData()}
Recent transactions: ${transactions.take(5).map((t) => {
                    'amount': t.amount,
                    'budgetId': t.budgetId,
                    'note': t.note,
                    'date': t.transactionDate.toIso8601String().split('T')[0]
                  }).toList()}

**Smart Processing Instructions:**
1. Match user intent with available data
2. Resolve ambiguities using context
3. Determine if sufficient info exists to proceed
4. Format final action plan

Respond with:

[ACTION:final_action_type]
[PARAMETERS:{"complete_json_parameters"}]
[CLARIFICATION:needed|none]
[CLARIFICATION_MESSAGE:specific_question_if_needed]
[SUCCESS_MESSAGE:confirmation_message_in_user_language]

**Action Types:**
- createBudget: Create new budget with parameters
- createTransaction: Add transaction to existing budget
- createBudgetAndTransaction: Create budget + first transaction
- provideBudgetAnalysis: Answer budget questions
- provideTransactionAnalysis: Answer transaction questions
- provideGeneralResponse: General conversation response

**Smart Matching Rules:**
- For transactions: Auto-match to existing budget by category/name
- For budget creation: Infer category from context
- For queries: Filter relevant data only
- For ambiguous cases: Ask specific clarifying questions
- Always respond in user's preferred language: ${userModel.languageCode}

**Examples:**
User: "I spent 50k on lunch" 
→ Match to existing Food budget or ask to create one

User: "Create food budget 500k"
→ Create Food budget with 500,000 limit

User: "How much did I spend this month?"
→ Analyze current month transactions across all budgets
""")
    ];
  }

  /// Extract action plan from AI context analysis response
  AIActionPlan _extractActionPlan(String contextAnalysis) {
    return AIActionPlan.fromAIResponse(contextAnalysis);
  }

  /// STEP 3: Execute AI-planned action with intelligent handling
  Future<AIExecutionResult> _executeAIPlannedAction(
      AIActionPlan actionPlan, BuildContext context) async {
    try {
      switch (actionPlan.actionType) {
        case 'createBudget':
          return await _executeCreateBudget(actionPlan.parameters, context);

        case 'createTransaction':
          return await _executeCreateTransaction(
              actionPlan.parameters, context);

        case 'createBudgetAndTransaction':
          return await _executeCreateBudgetAndTransaction(
              actionPlan.parameters, context);

        case 'provideBudgetAnalysis':
          return await _executeProvideBudgetAnalysis(
              actionPlan.parameters, context);

        case 'provideTransactionAnalysis':
          return await _executeProvideTransactionAnalysis(
              actionPlan.parameters, context);

        case 'provideGeneralResponse':
          return AIExecutionResult(
            success: true,
            successMessage: actionPlan.successMessage,
            errorMessage: '',
            resultData: {},
          );

        default:
          return AIExecutionResult(
            success: false,
            successMessage: '',
            errorMessage: 'Unknown action type: ${actionPlan.actionType}',
            resultData: {},
          );
      }
    } catch (e) {
      logError('Error executing AI planned action: $e');
      return AIExecutionResult(
        success: false,
        successMessage: '',
        errorMessage: 'Execution failed: $e',
        resultData: {},
      );
    }
  }

  /// AI-driven budget creation with intelligent parameter handling
  Future<AIExecutionResult> _executeCreateBudget(
      Map<String, dynamic> parameters, BuildContext context) async {
    try {
      final budgetRepository = _ref.read(budgetRepositoryProvider);
      final budgetController = _ref.read(budgetBaseControllerProvider.notifier);
      final user = _ref.read(userBaseControllerProvider);

      // Extract parameters with intelligent defaults
      final budgetName = parameters['budgetName'] as String? ?? 'New Budget';
      final categoryStr = parameters['category'] as String? ?? 'miscellaneous';
      final budgetTypeStr = parameters['budgetType'] as String? ?? 'expense';
      final budgetLimit = (parameters['budgetLimit'] as num?)?.toInt() ?? 0;
      final rangeTypeStr = parameters['rangeType'] as String? ?? 'month';

      // Smart category detection
      final category = IconCategory.fromString(categoryStr);
      final budgetType = budgetTypeStr == 'income'
          ? BudgetTypeEnum.income
          : BudgetTypeEnum.expense;
      final rangeType = _parseRangeDateTimeType(rangeTypeStr);

      // Smart date calculation
      final now = DateTime.now();
      final (startDate, endDate) = _calculateDateRange(rangeType, now);

      final newBudget = BudgetModel(
        id: GenId.budget(),
        userId: _uid,
        name: ViBotService.formatBudgetName(budgetName),
        iconName: IconManagerData.getIconByCategory(category).name,
        currentAmount: 0,
        budgetLimit: budgetLimit,
        budgetTypeValue: budgetType.value,
        rangeDateTimeTypeValue: rangeType.value,
        startDate: startDate,
        endDate: endDate,
        createdDate: now,
        updatedDate: now,
      );

      final result = await budgetRepository.addBudget(model: newBudget);

      return result.fold(
        (failure) => AIExecutionResult(
          success: false,
          successMessage: '',
          errorMessage: failure.message,
          resultData: {},
        ),
        (_) {
          budgetController.addBudgetState(newBudget);

          final successMessage = user.languageCode == 'vi'
              ? '✅ Đã tạo ngân sách "${newBudget.name}" thành công!'
              : '✅ Successfully created budget "${newBudget.name}"!';

          return AIExecutionResult(
            success: true,
            successMessage: successMessage,
            errorMessage: '',
            resultData: {
              'budgetId': newBudget.id,
              'budgetName': newBudget.name
            },
          );
        },
      );
    } catch (e) {
      logError('Error creating budget: $e');
      return AIExecutionResult(
        success: false,
        successMessage: '',
        errorMessage: 'Failed to create budget: $e',
        resultData: {},
      );
    }
  }

  /// AI-driven transaction creation with smart budget matching
  Future<AIExecutionResult> _executeCreateTransaction(
      Map<String, dynamic> parameters, BuildContext context) async {
    try {
      final transactionRepository = _ref.read(transactionRepositoryProvider);
      final user = _ref.read(userBaseControllerProvider);
      final budgets = _ref.read(budgetBaseControllerProvider);

      // Extract required parameters
      final amount = (parameters['amount'] as num?)?.toInt();
      final budgetId = parameters['budgetId'] as String?;
      final budgetName = parameters['budgetName'] as String?;
      final note = parameters['note'] as String? ?? '';
      final transactionDateStr = parameters['transactionDate'] as String?;

      if (amount == null) {
        return AIExecutionResult(
          success: false,
          successMessage: '',
          errorMessage: 'Amount is required for transaction',
          resultData: {},
        );
      }

      // Smart budget matching
      BudgetModel? targetBudget;
      if (budgetId != null) {
        targetBudget = budgets.firstWhere((b) => b.id == budgetId,
            orElse: () => budgets.first);
      } else if (budgetName != null) {
        targetBudget = budgets.firstWhere(
          (b) => b.name.toLowerCase().contains(budgetName.toLowerCase()),
          orElse: () => budgets.first,
        );
      } else {
        // Find best matching budget based on amount and context
        targetBudget = budgets.isNotEmpty ? budgets.first : null;
      }

      if (targetBudget == null) {
        return AIExecutionResult(
          success: false,
          successMessage: '',
          errorMessage: 'No suitable budget found for transaction',
          resultData: {},
        );
      }

      // Parse transaction date
      final transactionDate = transactionDateStr != null
          ? DateTime.tryParse(transactionDateStr) ?? DateTime.now()
          : DateTime.now();

      final finalNote =
          note.isEmpty ? AppLocalizations.of(context).createdByViBot : note;

      final result = await transactionRepository.addBudgetTransaction(
        user: user,
        budgetModel: targetBudget,
        amount: amount,
        note: finalNote,
        transactionDate: transactionDate,
      );

      return result.fold(
        (failure) => AIExecutionResult(
          success: false,
          successMessage: '',
          errorMessage: failure.message,
          resultData: {},
        ),
        (success) {
          final (transaction, updatedBudget, updatedUser) = success;

          // Update states
          _ref.read(userBaseControllerProvider.notifier).reload(updatedUser);
          _ref
              .read(budgetBaseControllerProvider.notifier)
              .updateState(updatedBudget);
          _ref
              .read(transactionsBaseControllerProvider.notifier)
              .addState(transaction);

          final successMessage = user.languageCode == 'vi'
              ? '✅ Đã ghi nhận giao dịch ${amount.abs()}đ vào "${targetBudget!.name}"!'
              : '✅ Recorded transaction \$${amount.abs()} to "${targetBudget!.name}"!';

          return AIExecutionResult(
            success: true,
            successMessage: successMessage,
            errorMessage: '',
            resultData: {
              'transactionId': transaction.id,
              'budgetId': targetBudget.id,
              'amount': amount,
            },
          );
        },
      );
    } catch (e) {
      logError('Error creating transaction: $e');
      return AIExecutionResult(
        success: false,
        successMessage: '',
        errorMessage: 'Failed to create transaction: $e',
        resultData: {},
      );
    }
  }

  /// AI-driven budget and transaction creation in sequence
  Future<AIExecutionResult> _executeCreateBudgetAndTransaction(
      Map<String, dynamic> parameters, BuildContext context) async {
    // First create the budget
    final budgetResult = await _executeCreateBudget(parameters, context);

    if (!budgetResult.success) {
      return budgetResult;
    }

    // Then create the transaction with the new budget
    final updatedParameters = Map<String, dynamic>.from(parameters);
    updatedParameters['budgetId'] = budgetResult.resultData['budgetId'];

    final transactionResult =
        await _executeCreateTransaction(updatedParameters, context);

    if (!transactionResult.success) {
      return transactionResult;
    }

    final user = _ref.read(userBaseControllerProvider);
    final successMessage = user.languageCode == 'vi'
        ? '✅ Đã tạo ngân sách "${budgetResult.resultData['budgetName']}" và ghi nhận giao dịch thành công!'
        : '✅ Created budget "${budgetResult.resultData['budgetName']}" and recorded transaction successfully!';

    return AIExecutionResult(
      success: true,
      successMessage: successMessage,
      errorMessage: '',
      resultData: {
        ...budgetResult.resultData,
        ...transactionResult.resultData,
      },
    );
  }

  /// AI-driven budget analysis with intelligent insights
  Future<AIExecutionResult> _executeProvideBudgetAnalysis(
      Map<String, dynamic> parameters, BuildContext context) async {
    try {
      final budgets = _ref.read(budgetBaseControllerProvider);
      final transactions = _ref
          .read(transactionsBaseControllerProvider)
          .map((e) => e.transaction)
          .toList();
      final user = _ref.read(userBaseControllerProvider);

      final analysisType = parameters['analysisType'] as String? ?? 'summary';
      final timeframe = parameters['timeframe'] as String? ?? 'month';
      final category = parameters['category'] as String?;

      String analysis = ViBotService.generateBudgetSummary(
        budgets: budgets,
        transactions: transactions,
        user: user,
        locale: user.languageCode,
      );

      // Enhanced analysis based on parameters
      if (category != null) {
        final categoryBudgets = budgets
            .where((b) => b.iconModel.category.name
                .toLowerCase()
                .contains(category.toLowerCase()))
            .toList();

        if (categoryBudgets.isNotEmpty) {
          final categoryAnalysis = user.languageCode == 'vi'
              ? '\n\n📊 **Phân tích danh mục $category:**\n'
              : '\n\n📊 **$category Category Analysis:**\n';

          analysis += categoryAnalysis;
          for (final budget in categoryBudgets) {
            final spent = transactions
                .where((t) => t.budgetId == budget.id)
                .fold(0, (sum, t) => sum + t.amount.abs());
            final percentage = budget.budgetLimit > 0
                ? (spent / budget.budgetLimit * 100).round()
                : 0;

            analysis +=
                '• ${budget.name}: $spent/${budget.budgetLimit} ($percentage%)\n';
          }
        }
      }

      return AIExecutionResult(
        success: true,
        successMessage: analysis,
        errorMessage: '',
        resultData: {'analysisType': analysisType, 'timeframe': timeframe},
      );
    } catch (e) {
      logError('Error providing budget analysis: $e');
      return AIExecutionResult(
        success: false,
        successMessage: '',
        errorMessage: 'Failed to analyze budgets: $e',
        resultData: {},
      );
    }
  }

  /// AI-driven transaction analysis with smart filtering
  Future<AIExecutionResult> _executeProvideTransactionAnalysis(
      Map<String, dynamic> parameters, BuildContext context) async {
    try {
      final transactions = _ref
          .read(transactionsBaseControllerProvider)
          .map((e) => e.transaction)
          .toList();
      final budgets = _ref.read(budgetBaseControllerProvider);
      final user = _ref.read(userBaseControllerProvider);

      final analysisType = parameters['analysisType'] as String? ?? 'recent';
      final timeframe = parameters['timeframe'] as String? ?? 'month';
      final category = parameters['category'] as String?;

      String analysis = _generateTransactionAnalysis(
        transactions: transactions,
        budgets: budgets,
        userMessage: 'Analysis request',
        locale: user.languageCode,
      );

      // Enhanced filtering based on parameters
      if (category != null) {
        final categoryBudgets = budgets
            .where((b) => b.iconModel.category.name
                .toLowerCase()
                .contains(category.toLowerCase()))
            .toList();

        final categoryTransactions = transactions
            .where((t) => categoryBudgets.any((b) => b.id == t.budgetId))
            .toList();

        if (categoryTransactions.isNotEmpty) {
          final categoryAnalysis = user.languageCode == 'vi'
              ? '\n\n💳 **Giao dịch danh mục $category:**\n'
              : '\n\n💳 **$category Transactions:**\n';

          analysis += categoryAnalysis;
          for (final transaction in categoryTransactions.take(5)) {
            final budget =
                budgets.firstWhere((b) => b.id == transaction.budgetId);
            analysis +=
                '• ${transaction.transactionDate.day}/${transaction.transactionDate.month}: ${transaction.amount} - ${budget.name}\n';
          }
        }
      }

      return AIExecutionResult(
        success: true,
        successMessage: analysis,
        errorMessage: '',
        resultData: {'analysisType': analysisType, 'timeframe': timeframe},
      );
    } catch (e) {
      logError('Error providing transaction analysis: $e');
      return AIExecutionResult(
        success: false,
        successMessage: '',
        errorMessage: 'Failed to analyze transactions: $e',
        resultData: {},
      );
    }
  }

  /// Smart date range calculation based on range type
  (DateTime, DateTime) _calculateDateRange(
      RangeDateTimeEnum rangeType, DateTime now) {
    switch (rangeType) {
      case RangeDateTimeEnum.week:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        return (weekStart, weekEnd);

      case RangeDateTimeEnum.month:
        final monthStart = DateTime(now.year, now.month, 1);
        final monthEnd = DateTime(now.year, now.month + 1, 0);
        return (monthStart, monthEnd);

      case RangeDateTimeEnum.year:
        final yearStart = DateTime(now.year, 1, 1);
        final yearEnd = DateTime(now.year, 12, 31);
        return (yearStart, yearEnd);

      case RangeDateTimeEnum.allTime:
        return (DateTime(2020, 1, 1), DateTime(2030, 12, 31));

      case RangeDateTimeEnum.custom:
        // For custom ranges, default to month
        final monthStart = DateTime(now.year, now.month, 1);
        final monthEnd = DateTime(now.year, now.month + 1, 0);
        return (monthStart, monthEnd);
    }
  }

  Future<List<ChatModel>> fetchASC() {
    return db
        .collection(FirestorePath.chats(uid: _uid))
        .mapModel<ChatModel>(
            modelFrom: ChatModel.fromMap, modelTo: (model) => model.toMap())
        .orderBy('createdDate')
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<bool> _writeToDB(List<ChatModel> chats) async {
    try {
      var batch = db.batch();
      chats.sort((a, b) => a.createdDate.compareTo(b.createdDate));
      for (var chat in chats) {
        final docRef =
            db.collection(FirestorePath.chats(uid: _uid)).doc(chat.id);
        batch.set(docRef, chat.toMap());
      }
      await batch.commit();
      return true;
    } catch (e) {
      logError('Failed to write chat to DB: $e');
      return false;
    }
  }


  /// Get the original user message from chat history
  String _getOriginalUserMessage() {
    final chats = _ref.read(chatBaseControllerProvider.notifier).chats;
    final userChats = chats
        .where((chat) =>
            RoleChatEnum.fromValue(chat.roleTypeValue) == RoleChatEnum.user)
        .toList();

    if (userChats.isNotEmpty) {
      userChats.sort((a, b) => b.createdDate.compareTo(a.createdDate));
      return userChats.first.message;
    }

    return '';
  }


}

class AIActionPlan {
  final String actionType;
  final Map<String, dynamic> parameters;
  final bool needsClarification;
  final String clarificationMessage;
  final String successMessage;
  final bool canExecute;

  const AIActionPlan({
    required this.actionType,
    required this.parameters,
    required this.needsClarification,
    required this.clarificationMessage,
    required this.successMessage,
    required this.canExecute,
  });

  factory AIActionPlan.fromAIResponse(String aiResponse) {
    final actionMatch = RegExp(r'\[ACTION:(\w+)\]').firstMatch(aiResponse);
    final parametersMatch =
        RegExp(r'\[PARAMETERS:(.*?)\]', dotAll: true).firstMatch(aiResponse);
    final needsClarificationMatch =
        RegExp(r'\[CLARIFICATION:(needed|none)\]').firstMatch(aiResponse);
    final clarificationMessageMatch =
        RegExp(r'\[CLARIFICATION_MESSAGE:(.*?)\]', dotAll: true)
            .firstMatch(aiResponse);
    final successMessageMatch =
        RegExp(r'\[SUCCESS_MESSAGE:(.*?)\]', dotAll: true)
            .firstMatch(aiResponse);

    Map<String, dynamic> parameters = {};
    if (parametersMatch != null) {
      try {
        parameters =
            jsonDecode(parametersMatch.group(1)!) as Map<String, dynamic>;
      } catch (e) {
        // Keep empty parameters if JSON parsing fails
      }
    }

    final needsClarification = needsClarificationMatch?.group(1) == 'needed';
    final clarificationMessage = clarificationMessageMatch?.group(1)?.trim() ??
        'I need more information to help you.';
    final successMessage = successMessageMatch?.group(1)?.trim() ??
        'Action completed successfully!';

    return AIActionPlan(
      actionType: actionMatch?.group(1) ?? 'askCommon',
      parameters: parameters,
      needsClarification: needsClarification,
      clarificationMessage: clarificationMessage,
      successMessage: successMessage,
      canExecute: !needsClarification && parameters.isNotEmpty,
    );
  }
}

class AIExecutionResult {
  final bool success;
  final String successMessage;
  final String errorMessage;
  final Map<String, dynamic> resultData;

  const AIExecutionResult({
    required this.success,
    required this.successMessage,
    required this.errorMessage,
    required this.resultData,
  });
}
