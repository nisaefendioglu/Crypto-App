import 'dart:convert';

class UtilService {

  static dynamic parsedOrDefault(String input, dynamic defaultValue) {
    dynamic output = defaultValue;
    try {
      output = json.decode(input);
    } catch(e) {
      output = defaultValue;
    }
    return output;
  }

  static List<dynamic> partition(List<dynamic> arr, int maxSize) {

    final out = [];
    var innerArr = [];

    for (int i = 0; i < arr.length; i++) {
      innerArr.add(arr[i]);
      if (innerArr.length == maxSize) {
        out.add(innerArr);
        innerArr = [];
      }
      if (i == arr.length - 1 && innerArr.length > 0) {
        out.add(innerArr);
      }
    }
    return out;
  }
}