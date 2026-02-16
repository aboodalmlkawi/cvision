class QRService {
  // توليد نص الـ QR الخاص بالسيرة الذاتية
  // يمكن أن يكون رابطاً لموقع، أو نص JSON يحتوي على البيانات
  String generateCVQRData(String cvId, String userId) {
    // مثال: رابط عميق (Deep Link) لفتح السيرة الذاتية في التطبيق
    // cvision://view_cv?id=xyz&user=abc
    return "cvision://view_cv?id=$cvId&uid=$userId";
  }

  // يمكن إضافة دالة لتحويل البيانات لنص JSON للمشاركة السريعة
  String generateContactQRData(String name, String phone, String email) {
    return "MECARD:N:$name;TEL:$phone;EMAIL:$email;;";
  }
}