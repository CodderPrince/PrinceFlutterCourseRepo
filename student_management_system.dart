import 'student.dart';
import 'teacher.dart';

class StudentManagementSystem {
  static void main(List<String> args) {
    Student student1 =
    Student("John Doe", 20, "123 Main St", "S123", "A", [90.0, 85.0, 82.0]);

    Teacher teacher1 = Teacher(
        "Mrs. Smith", 35, "456 Oak St", "T456", ["Math", "English", "Bangla"]);

    student1.displayStudentInfo();
    print("\n");
    teacher1.displayTeacherInfo();
  }
}
