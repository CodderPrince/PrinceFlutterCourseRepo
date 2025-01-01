import 'person.dart';
import 'role.dart';

//override display role
class StudentRole implements Role {
  @override
  void displayRole() {
    print("Role: Student");
  }
}

//create student class
class Student extends Person {
  //additional attributes
  int studentID; //assume for numeric numbers only
  String grade;
  List<double> courseScores;

  //constructor
  Student(String name, int age, String address, int studentID, String grade,
      List<double> courseScores)
      : this.studentID = studentID,
        this.grade = grade,
        this.courseScores = courseScores,
        super(name, age, address, StudentRole());

//average score
  double calAvg() {
    //base case
    if (courseScores.isEmpty) {
      return 0.0;
    }

    double sum = 0.0;
    for (double score in courseScores) {
      sum += score;
    }
    return sum / courseScores.length;
  }

  //display
  void disStdInfo() {
    print("Student Information:");
    displayRole();
    print("Name: $name");
    print("Age: $age");
    print("Address: $address");
    print("Average Score: ${calAvg().toStringAsFixed(2)}");
  }
}
