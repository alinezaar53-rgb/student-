class FormValidators {
  static String? requiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) return 'يرجى إدخال $label';
    return null;
  }

  static String? loginIdentifier(String? value) {
    final required = requiredText(value, 'المعرف الأكاديمي أو البريد');
    if (required != null) return required;
    if (value!.trim().length < 5) return 'يجب ألا يقل المعرف عن 5 خانات';
    return null;
  }

  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور';
    if (value.length < 6) return 'كلمة المرور يجب أن تكون 6 محارف على الأقل';
    return null;
  }

  static String? fullName(String? value) {
    final required = requiredText(value, 'الاسم الكامل');
    if (required != null) return required;
    if (value!.trim().length < 3) return 'الاسم يجب أن يكون 3 محارف على الأقل';
    return null;
  }

  static String? academicId(String? value) {
    final required = requiredText(value, 'الرقم الأكاديمي');
    if (required != null) return required;
    if (!RegExp(r'^\d{9,10}$').hasMatch(value!.trim())) {
      return 'الرقم الأكاديمي يجب أن يتكون من 9 إلى 10 أرقام';
    }
    return null;
  }

  static String? universityEmail(String? value) {
    final required = requiredText(value, 'البريد الجامعي');
    if (required != null) return required;
    if (!RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
        .hasMatch(value!.trim())) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }
    return null;
  }

  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور';
    if (value.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(value) ||
        !RegExp(r'\d').hasMatch(value)) {
      return 'يجب أن تتكون من 8 محارف على الأقل، وحرف كبير ورقم';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'يرجى تأكيد كلمة المرور';
    if (value != original) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  static String? resetIdentifier(String? value) {
    final required = requiredText(value, 'البريد أو الرقم الأكاديمي');
    if (required != null) return required;
    if (value!.trim().length < 5) return 'أدخل معرفاً صحيحاً';
    return null;
  }

  static String? otp(String? value) {
    if (value == null || !RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'رمز التحقق يجب أن يتكون من 6 أرقام';
    }
    return null;
  }
}
