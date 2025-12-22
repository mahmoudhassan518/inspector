import 'package:inspector_network/inspector_network.dart';
import 'package:inspector/features/localization/data/source/language_local_data_source.dart';
import 'package:inspector/features/localization/domain/model/language.dart';

/// Auth and language header provider implementation
class AuthHeaderProvidersImpl implements AuthHeaderProvider {
  final LanguageLocalDataSource _languageDataSource;

  AuthHeaderProvidersImpl({required LanguageLocalDataSource languageDataSource})
      : _languageDataSource = languageDataSource;

  @override
  Future<Map<String, String>> buildAuthHeaders(String accessToken) async {
    final languageCode = await _languageDataSource.getLanguageCode() ?? Language.english.code;
    return {
      'Authorization': 'Bearer $accessToken',
      'Accept-Language': languageCode,
    };
  }
}