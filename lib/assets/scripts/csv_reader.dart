import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class MyCsvReader {




  Future loadData() async {
    String csvData = await rootBundle.loadString(
        '/media/course_college_rel_demo.csv');
    List<List<dynamic>> data = const CsvToListConverter().convert(csvData);

    return  data;

  }
}
