class Capitalize {
  static String capitalizeFirstLetter(String str) {
    if (str == null || str.isEmpty) {
      return str;
    }
    return str[0].toUpperCase() + str.substring(1);
  }
}