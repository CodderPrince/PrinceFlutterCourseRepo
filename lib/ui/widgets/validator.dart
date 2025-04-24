validator(
  String value, {
  RegExp? regExp,
  String? isEmptyTitle,
  String? alertTitle,
}) {
  if (regExp != null) {
    if (value.trim().isEmpty == true) {
      return isEmptyTitle;
    } else if (regExp.hasMatch(value) == false) {
      return alertTitle;
    }
    return null;
  }
  if (value.trim().isEmpty == true) {
    return isEmptyTitle;
  }
  return null;
}
