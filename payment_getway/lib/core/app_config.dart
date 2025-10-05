import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig{
  static final AppConfig _instance = AppConfig._();

  static AppConfig get instance => _instance;

  String? _baseUrl;

  String get baseUrl => _baseUrl!;

  String? _razorpayKey;

  String get razorpayKey => _razorpayKey!;


  AppConfig._();

  Future<void> load() async{
    await dotenv.load(fileName: '.env');
    _loadValue();
  }

  void _loadValue(){
    _baseUrl = _get(key: 'BASE_URL');
    _razorpayKey = _get(key: 'RAZORPAY_KEY');
  }

  String _get({required String key}) {
    final String? value = dotenv.maybeGet(key);

    if(value == null || value.isEmpty){
      throw Exception("$key not found in .env file");
    }
    return value;
  }
}