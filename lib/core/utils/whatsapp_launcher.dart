import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';

/// Opens a WhatsApp chat with Ylmar. An optional [message] pre-fills the chat.
Future<void> launchWhatsApp({String? message}) async {
  // wa.me expects the number in international format without '+' or spaces.
  final number = AppConstants.whatsApp.replaceAll(RegExp(r'[^0-9]'), '');
  final text = message != null ? '?text=${Uri.encodeComponent(message)}' : '';
  final uri = Uri.parse('https://wa.me/$number$text');
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
