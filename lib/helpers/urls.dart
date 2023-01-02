class Urls {
  static const String baseUrlEmulator = 'http://10.0.2.2:8000/api';

  static const String baseUrl = 'http://127.0.0.1:8000/api';

  //authentication
  static const String login = '$baseUrlEmulator/login';
  static const String registration = '$baseUrlEmulator/register';
  static const String logout = '$baseUrlEmulator/logout';

  //notes
  static const String notes = '$baseUrlEmulator/notes';

  //user
  static const String user = '$baseUrlEmulator/user';

  //profile
  static const String mail = 'hansi@mail.com';
  static const String password = 'hansi1234';
}
