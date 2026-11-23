import 'package:url_launcher/url_launcher.dart';

/// Opens an external [url] safely across Web, Desktop, and Mobile.
Future<void> openExternalUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  await launchUrl(uri, mode: LaunchMode.platformDefault);
}
