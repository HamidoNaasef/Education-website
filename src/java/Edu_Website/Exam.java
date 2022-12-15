package Edu_Website;

import java.io.File;
import java.io.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.*;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;

public class Exam extends Model{
    String exam_name = "";
    String start_date = "";
    String end_date = "";
    String end_time = "";
    int duration = 0;
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    public String get_name(){return this.exam_name;}
    ////////////////////////////////////////////////////////////////////////////////////////////
    public Date get_sdate(){return Date.valueOf( (this.start_date).substring(0, this.start_date.indexOf(' ')) );}
    ////////////////////////////////////////////////////////////////////////////////////////////
    public Date get_edate(){return Date.valueOf( (this.end_date).substring(0, this.end_date.indexOf(' ')) );}
    ////////////////////////////////////////////////////////////////////////////////////////////
    public Time get_etime(){return Time.valueOf( (this.end_date).substring(this.end_date.indexOf(' ')+1 , (this.end_date).lastIndexOf(':')) + ":00");}
    ////////////////////////////////////////////////////////////////////////////////////////////
    public int get_duration(){return this.duration;}
    ////////////////////////////////////////////////////////////////////////////////////////////
    public ArrayList<HPair> get_exams_of_subject(String subId) throws Exception{
        ArrayList<HPair> exams = new ArrayList<>();
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "SELECT exam_id, exam_name FROM grandmaster.exam where sub_of_exam = '" + subId + "';";
            try (ResultSet res = stmt.executeQuery(query)) {
                while(res.next()){
                    //HPair (exam id, exam name,)
                    exams.add(new HPair(res.getString("exam_id"), res.getString("exam_name") ));
                }
                
                res.close();
                stmt.close();
                con.close();
            }
        }
        
        return exams;
    } 
    ////////////////////////////////////////////////////////////////////////////////////////////
    public int get_attendance(String exam_id) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "select count(student_id) as attendance from student_grade where exam_id = '" + exam_id + "';";
            try (ResultSet res = stmt.executeQuery(query)) {
                res.next();
                int attendance = res.getInt("attendance");
                
                res.close();
                stmt.close();
                con.close();
                return attendance;
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public String insert_exam(String exam_name, String sub_id, String start_date, String end_date, String end_time,int duration) throws Exception{
        String examid = "ex-" + java.time.LocalDate.now() + "-";
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query_1 = "select count(exam_id) as numberofexams FROM exam;";
            String insert_exam;
            // get the number of exams
            try (Statement stmt2 = con.createStatement();ResultSet temp_res = stmt.executeQuery(query_1)) {
              
                temp_res.next();
                int temp_int;
                temp_int = temp_res.getInt("numberofexams");
                temp_int++;
                examid += temp_int;
                
                // inserting exam to DB
                insert_exam = "insert into exam values ('" + examid + "', '" + exam_name + "',"
                        + " '" + sub_id + "', '" + start_date + " 00:01:10', '" + end_date +" "+ end_time + "',"
                        + " " + duration + ");";
                
                stmt2.executeUpdate(insert_exam);
                
                temp_res.close();
                stmt.close();
                stmt2.close();
                con.close();
            }
        }
        return examid;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public boolean is_exam_exist(String examID) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = "SELECT * FROM grandmaster.exam where exam_id = '" + examID + "';";
            try (ResultSet res = stmt.executeQuery(select_user)) {
                if(res.next()){
                    res.close();
                    stmt.close();
                    con.close();
                    return true;
                }
                res.close();
            }
            stmt.close();
            con.close();
        }
        
        return false;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public void get_exam_info(String exam_id) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "SELECT * FROM grandmaster.exam where exam_id = '" + exam_id + "';";
            try (ResultSet res = stmt.executeQuery(query)) {
                res.next();
                        
                this.exam_name = res.getString("exam_name");
                this.start_date = res.getString("start_of_exam");
                this.end_date = res.getString("end_of_exam");
                this.end_time = res.getString("end_of_exam");
                this.duration = res.getInt("duration");               
                
                res.close();
                stmt.close();
                con.close();
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public void update_exams_info(String id, String name, String sdate, String edate, String etime, int duration) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String update_exam_info = "update exam set exam_name = '" + name + "',  start_of_exam = '" + sdate + " 00:01:00',"
                    + " end_of_exam = '" + edate + " " + etime + "', duration = " + duration + " "
                    + "where exam_id = '" + id + "';";
                
            // update question in DB
            stmt.executeUpdate(update_exam_info);
            
            stmt.close();
            con.close();
            
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public String delete_exam(String exam_id) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query_0 = "delete from grandmaster.student_exam_start_time where exam_id = '" + exam_id + "';";
            String query_1 = "delete from student_grade where student_grade.exam_id = '" + exam_id + "';";
            String query_2 = "delete from exam_question where exam_question.exam_id = '" + exam_id + "';";
            String query_3 = "delete from exam where exam.exam_id = '" + exam_id + "';";
                
            // update question in DB
            stmt.executeUpdate(query_0);
            stmt.executeUpdate(query_1);
            stmt.executeUpdate(query_2);
            stmt.executeUpdate(query_3);
            
            
            stmt.close();
            con.close();
            return "";
            
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public ArrayList<HPair> get_student_grades(String exam_Id) throws SQLException{
        ArrayList<HPair> studentGrade= new ArrayList<>();
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "SELECT user.fname, user.lname, student_id, exam_id, grade "
                    + "FROM grandmaster.student_grade join user on user.user_id = student_id "
                    + "where exam_id = '" + exam_Id + "' order by grade desc;";
            try (ResultSet res = stmt.executeQuery(query)) {
                while(res.next()){
                    // answers file = exam id + student id + '.txt'
                    studentGrade.add(new HPair( res.getString("exam_id") + res.getString("student_id"),
                            res.getString("fname")+ res.getString("lname"), res.getString("grade") ));
                }
                
                res.close();
                stmt.close();
                con.close();
                return studentGrade;
            }
        }
        
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public boolean can_exam(String exam_id) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "select start_of_exam, end_of_exam from exam where exam_id = '" + exam_id + "';";
            Date current_date = Date.valueOf(java.time.LocalDate.now());
            Time current_time = Time.valueOf(LocalTime.now());
            
            
            try (ResultSet res = stmt.executeQuery(query)) {
                res.next();
                String start = res.getString("start_of_exam");        
                String end = res.getString("end_of_exam");        
                
                Date s_date = Date.valueOf( start.substring(0, start.indexOf(' ')) );
                Date e_date = Date.valueOf( end.substring(0, end.indexOf(' ')) );
                Time e_time = Time.valueOf( end.substring(end.indexOf(' ')+1 , end.lastIndexOf(':')) + ":00");    
                
                res.close();
                stmt.close();
                con.close();
                
                if(current_date.after(e_date) || current_date.before(s_date)){
//                    System.err.println("No exam");
                    return false;
                }else if(current_date.equals(e_date)) {
                    return !current_time.after(e_time);
                    
                }else{
                    return true;
                }
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public boolean can_view_answer(String exam_id) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "select end_of_exam from exam where exam_id = '" + exam_id + "';";
            Date current_date = Date.valueOf(java.time.LocalDate.now());
            Time current_time = Time.valueOf(LocalTime.now());
            
            
            try (ResultSet res = stmt.executeQuery(query)) {
                res.next();       
                String end = res.getString("end_of_exam");        
                
                Date e_date = Date.valueOf( end.substring(0, end.indexOf(' ')) );
                Time e_time = Time.valueOf( end.substring(end.indexOf(' ')+1 , end.lastIndexOf(':')) + ":00");    
                
                res.close();
                stmt.close();
                con.close();
                
                if(current_date.after(e_date)){
                    return true;
                }else if(current_date.equals(e_date)) {
                    return current_time.after(e_time);
                }else{
                    return false;
                }
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public boolean is_correct(String question_id, String answer) throws SQLException{
         try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = "select * from exam_question "
                    + "where exam_question.q_id = '" + question_id + "' and answer = '" + answer + "';";
            try (ResultSet res = stmt.executeQuery(select_user)) {
                if(res.next()){
                    res.close();
                    stmt.close();
                    con.close();
                    return true;
                }
                res.close();
            }
            stmt.close();
            con.close();
        }
        
        return false;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public String get_related_subject_id(String exam_id) throws Exception{
        String subject_id;
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "select sub_of_exam from exam where exam_id = '" + exam_id + "';";
            try (ResultSet res = stmt.executeQuery(query)) {
                res.next();

                subject_id = res.getString("sub_of_exam");
                res.close(); 
            }
            stmt.close();
            con.close();
        }
        return subject_id;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public boolean is_examed(String exam_id, String student_id) throws SQLException{
         try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "select grade from student_grade "
                    + "where student_id = '" + student_id + "' and exam_id = '" + exam_id + "';";
            try (ResultSet res = stmt.executeQuery(query)) {
                if(res.next()){
                    res.close();
                    stmt.close();
                    con.close();
                    return true;
                }
                res.close();
            }
            stmt.close();
            con.close();
        }
        
        return false;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public void store_grade_to_db(String exam_id, String Student_id, int grade) throws SQLException{
         try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "insert into student_grade values('" + Student_id + "', '" + exam_id + "', " + grade + ");";
            
            stmt.executeUpdate(query);
            stmt.close();
            con.close();
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
     public int get_student_grade(String exam_id, String student_id) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "select grade from student_grade "
                    + "where student_id = '" + student_id + "' and exam_id = '" + exam_id + "';";
            try (ResultSet res = stmt.executeQuery(query)) {
                res.next();              
               int grade = res.getInt("grade");
                
                res.close();
                stmt.close();
                con.close();
                return grade;
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public boolean is_exam_page_reloaded(String exam_id, String Stud_id) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "SELECT student_start_timecol FROM grandmaster.student_exam_start_time "
                    + "where exam_id = '" + exam_id + "' and student_id = '" + Stud_id + "';";            
            try (ResultSet res = stmt.executeQuery(query)) {
                if(res.next()){
                    res.close();
                    stmt.close();
                    con.close();
                    return true;
                }
                res.close();
                stmt.close();
                con.close();
            }
        }
        return false;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public int get_remaining_time(String exam_id, String Stud_id) throws Exception{
        int remaining_minutes = 0;
        Exam exam = new Exam();
        LocalDateTime currentTime = LocalDateTime.now();
        
        Duration diff_duration;
        
        String fisrtView;
        exam.get_exam_info(exam_id);
        
        // get time of first seen of exam
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "SELECT student_start_timecol FROM grandmaster.student_exam_start_time "
                    + "where exam_id = '" + exam_id + "' and student_id = '" + Stud_id + "';";            
            try (ResultSet res = stmt.executeQuery(query)) {
                res.next();
                fisrtView = res.getString("student_start_timecol").replace(' ', 'T');
                res.close();
                stmt.close();
                con.close();
            }
        }
        diff_duration = Duration.between(LocalDateTime.parse(fisrtView), currentTime);
        
        
        
        if(diff_duration.toMinutes() < exam.get_duration()){
            remaining_minutes = exam.get_duration() - (int)diff_duration.toMinutes();
        }
        
        return remaining_minutes;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public String set_first_view(String exam_id, String Stud_id) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "insert into grandmaster.student_exam_start_time "
                    + "values('" + Stud_id + "', '" + exam_id + "', '" +
                    (java.time.LocalDateTime.now().toString().replace('T', ' ')) + "');";            
            
            stmt.executeUpdate(query);
            stmt.close();
            con.close();
            return "dsa ";
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public void store_answers_to_files(String exam_id, String Student_id, String question_id, String answer) throws Exception{
        Path path = Paths.get("examAnswers");
        String ditctory = path.toAbsolutePath().toString();
        File file = new File(ditctory + '\\' + exam_id + Student_id + ".txt");
        
        try (FileWriter fw = new FileWriter(file, true)) {
            fw.write(question_id + "$" + answer + "&");
            fw.close();
        }catch(Exception efile){
            System.err.println("Error in wrting to file in exam:");
        }
        
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    public ArrayList<HPair> get_answers_from_file(String sheetId) throws Exception{
        Path path = Paths.get("examAnswers");
        String ditctory = path.toAbsolutePath().toString();
        File file = new File(ditctory + '\\' + sheetId + ".txt");
        ArrayList<HPair> answers= new ArrayList<>();
        String answerLoader = "";
        
        try (FileReader fr = new FileReader(file)) {
            int content;
            while ((content = fr.read()) != -1) {
                if((char) content == '&'){
                    answers.add(new HPair(answerLoader.substring(0, answerLoader.indexOf('$')), answerLoader.substring(answerLoader.indexOf('$')+1) ));
                    answerLoader = "";
                }else{
                    answerLoader += ((char) content);
                }
            }
            fr.close();
        }catch(Exception efile){
            System.err.println("Error in reading from file in exam:");
        }
        
        return answers;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
        
}
