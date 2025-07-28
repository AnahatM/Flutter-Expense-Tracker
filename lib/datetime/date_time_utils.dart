// Convert DateTime object to a string in 'yyyy-mm-dd' format
String convertDateTimeToString(DateTime date) {
  String year = date.year.toString();

  String month = date.month.toString();
  if (month.length < 2) {
    month = '0$month'; // Add leading zero if needed
  }

  String day = date.day.toString();
  if (day.length < 2) {
    day = '0$day'; // Add leading zero if needed
  }

  return '$year$month$day';
}

String formatDateTimeDisplay(DateTime date) {
  return '${date.day} / ${date.month} / ${date.year}';
}
