require 'pry'

class Student
  attr_accessor :id, :name, :grade
  @@all = []

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    students = DB[:conn].execute("SELECT * FROM students")
    students.each{|student| 
      @@all.push(self.new_from_db(student))
    }
    @@all
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    students = DB[:conn].execute("SELECT * FROM students")
    student_index = nil
    students.each_with_index {|student, index|
      if student[1] == name
        student_index = index
      end
    }
    self.new_from_db(students[student_index])
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    all_students_in_grade_9 = []
    students = DB[:conn].execute("SELECT * FROM students WHERE students.grade = 9")
    students.each {|student|
      student_obj = self.new_from_db(student)
      all_students_in_grade_9.push(student_obj)
    }
    all_students_in_grade_9
  end

  def self.students_below_12th_grade
    students_below_12th_grade = []
    students = DB[:conn].execute("SELECT * FROM students WHERE students.grade != 12")
    students.each {|student|
      student_obj = self.new_from_db(student)
      students_below_12th_grade.push(student_obj)
    }
    students_below_12th_grade
  end

  def self.first_X_students_in_grade_10(x)
    first_X_students_in_grade_10 = []
    students = DB[:conn].execute("SELECT * FROM students WHERE students.grade = 10 LIMIT #{x}")
    students.each {|student|
      student_obj = self.new_from_db(student)
      first_X_students_in_grade_10.push(student_obj)
    }
    first_X_students_in_grade_10
  end

  def self.first_student_in_grade_10
    first_student_in_grade_10 = []
    student = DB[:conn].execute("SELECT * FROM students WHERE students.grade = 10 LIMIT 1")
    self.new_from_db(student[0])
  end

  def self.all_students_in_grade_X(x)
    all_students_in_grade_X = []
    students = DB[:conn].execute("SELECT * FROM students WHERE students.grade = #{x}")
    students.each {|student|
      student_obj = self.new_from_db(student)
      all_students_in_grade_X.push(student_obj)
    }
    all_students_in_grade_X
  end
end
