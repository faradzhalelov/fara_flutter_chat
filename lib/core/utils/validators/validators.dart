/// Utility class for form validation
class Validators {
  const Validators._(); // Private constructor to prevent instantiation
  
  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите email';
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Введите корректный email';
    }
    
    return null;
  }
  
  /// Validates password with minimum length requirement
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    
    if (value.length < 6) {
      return 'Пароль должен содержать минимум 6 символов';
    }
    
    return null;
  }
  
  /// Validates that password confirmation matches the password
  static String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Подтвердите пароль';
    }
    
    if (value != password) {
      return 'Пароли не совпадают';
    }
    
    return null;
  }
  
  /// Validates username with minimum length requirement
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите имя пользователя';
    }
    
    if (value.length < 3) {
      return 'Имя должно содержать минимум 3 символа';
    }
    
    return null;
  }
  
  /// Validates that the field is not empty
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return 'Поле ${fieldName ?? ''} обязательно для заполнения';
    }
    
    return null;
  }
}