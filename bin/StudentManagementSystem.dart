import 'student.dart';
import 'teacher.dart';

//create class
class StudentManagementSystem {
  //main method
  static void main(List<String> args) {
    //Student instances
    Student student1 =
        Student("John Doe", 20, "123 Main St", 123, "A+", [90.0, 85.0, 82.0]);

    //Teacher instances
    Teacher teacher1 = Teacher(
        "Mrs. Smith", 35, "456 Oak St", 456, ["Math", "English", "Bangla"]);

    //displayRole
    student1.disStdInfo();
    print("\n");

    teacher1.disTI();
  }
}
