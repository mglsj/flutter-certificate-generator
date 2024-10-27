import 'package:certificate/helpers/extensions.dart';
import 'package:certificate/helpers/students.dart';
import 'package:excel/excel.dart';

String cleanValue(String s) {
  if (s.toUpperCase() == 'NULL' ||
      s.toUpperCase() == 'N/A' ||
      s.toUpperCase() == 'NONE') {
    return '';
  }
  return s;
}

List<Student> loadStudents(Excel excel, int nameIndex, int courseIndex,
    int semIndex, int? sectionIndex, int? idIndex) {
  List<Student> studentsData = [];

  var table = excel.tables[excel.tables.keys.first]!;
  var rows = table.rows.sublist(1);

  for (var row in rows) {
    var name = cleanValue(
      (row[nameIndex]?.value.toString() ?? "").toTitleCase(),
    );
    var course = cleanValue(
      (row[courseIndex]?.value.toString() ?? "").toUpperCase(),
    );
    var sem = cleanValue(
      row[semIndex]?.value.toString() ?? "",
    );
    var section = cleanValue(
      (sectionIndex != null ? row[sectionIndex]?.value.toString() ?? "" : "")
          .toUpperCase(),
    );
    var id = cleanValue(
      idIndex != null ? row[idIndex]?.value.toString() ?? "" : "",
    );

    if ((name.isEmpty || course.isEmpty)) {
      continue;
    }

    studentsData.add(
      Student(
        name: name,
        course: course,
        sem: sem,
        section: section,
        id: id,
      ),
    );
  }

  return studentsData;
}
