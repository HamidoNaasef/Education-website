package Edu_Website;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Subject extends Model{
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////
    public boolean is_code_available(String code) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = "select * FROM subject where sub_Code = '" + code + "';";
            try (ResultSet res = stmt.executeQuery(select_user)) {
                if(res.next()){
                    res.close();
                    stmt.close();
                    con.close();
                    return false;
                }
            }
            stmt.close();
            con.close();
        }
        return true;
    }
    ////////////////////////////////////////////////////////////////////////////
    public boolean is_name_available(String name) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = "select * FROM subject where sub_name = '" + name + "';";
            try (ResultSet res = stmt.executeQuery(select_user)) {
                if(res.next()){
                    res.close();
                    stmt.close();
                    con.close();
                    return false;
                }
                res.close();
            }
            stmt.close();
            con.close();
        }
        return true;
    }
    ////////////////////////////////////////////////////////////////////////////
    public boolean is_id_exist(String subId) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = "select * FROM subject where sub_Id = '" + subId + "';";
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
    ////////////////////////////////////////////////////////////////////////////
    public boolean add_new_subject(String name, String code, String pass, int year, String supervisorId) throws Exception{
        String subid;
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String count_subject = "select count(sub_Id) as subnumber from subject;";
            String add_subject = "";
            
            // get the number of user
            try (Statement stmt2 = con.createStatement();ResultSet temp_res = stmt.executeQuery(count_subject)) {
              
                temp_res.next();
                int subject_counter;
                subject_counter = temp_res.getInt("subnumber");
                subject_counter++;
                subid = "sub-" + subject_counter;
                
                // inserting subject to DB
                add_subject = "insert into grandmaster.subject values " +
                "('" + subid + "', '" + name + "', '" + code + "', '" + pass + "'," +
                    year + ", '" + supervisorId + "', '" + java.time.LocalDate.now() + "');";
                stmt2.executeUpdate(add_subject);
                
                temp_res.close();
                stmt.close();
                stmt2.close();
                return true;
            }catch(Exception ein){
                System.err.println("Error in adding subject second try!!");
                System.err.println("Query ==> " + add_subject);
            }
            con.close();
        }catch(Exception eout){
                System.err.println("Error in adding subject first try!!");
            }
        
        return false;
    }
    ////////////////////////////////////////////////////////////////////////////
    public ArrayList<HPair> get_w2e_students(String TeacherId) throws Exception{
        ArrayList<HPair> w2eStud= new ArrayList<>();
        
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String get_student = "select sub_name, subject_id, waiting_2b_enrolled_student.student_id " +
            "From (subject join waiting_2b_enrolled_student on waiting_2b_enrolled_student.subject_id = subject.sub_Id ) "
            + " join user on supervisorId = user_id "
            + " where user_id = '" + TeacherId + "';";
            try (ResultSet res = stmt.executeQuery(get_student)) {
                while(res.next()){
                    w2eStud.add(new HPair(res.getString("subject_id"), res.getString("sub_name"), res.getString("student_id")));
                }
                res.close();
                stmt.close();
                con.close();
            }
        }
        return w2eStud;  
    }
    ////////////////////////////////////////////////////////////////////////////
    public void acceptEnrolment(String studId, String subId) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "insert into enrolled_student values('" + studId + "', '" + subId + "', '" + java.time.LocalDate.now() + "');";
            stmt.executeUpdate(query);
            
            stmt.close();
            con.close();
        }
    }
    ////////////////////////////////////////////////////////////////////////////
    public void refuseEnrolment(String studId, String subId)throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "delete from waiting_2b_enrolled_student where student_id = '" + studId + "'and subject_id = '" + subId + "';";
            stmt.executeUpdate(query);
            
            stmt.close();
            con.close();
        }
    }
    ////////////////////////////////////////////////////////////////////////////
    public String get_subjectName(String sub_id) throws Exception{
        String sub_name;
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "select sub_name from subject where sub_Id = '" + sub_id + "';";
            try (ResultSet res = stmt.executeQuery(query)) {
                res.next();
                sub_name = res.getString("sub_name");
                res.close();
                stmt.close();
                con.close();
            }
        }
        return sub_name;
    }
    ////////////////////////////////////////////////////////////////////////////
    public int count_enrolled_students(String sub_id) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "select count(student_id) as attendance from enrolled_student where subject_id = '" + sub_id + "';;";
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
    ////////////////////////////////////////////////////////////////////////////
    public ArrayList<HPair> get_enrolled_student_names(String subId) throws Exception{
        ArrayList<HPair> eStud= new ArrayList<>();
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String get_student = "select enrolled_student.student_id, user.fname, user.lname "
                    + "from user join enrolled_student on user_id = enrolled_student.student_id "
                    + "where enrolled_student.subject_id = '" + subId + "';";
            try (ResultSet res = stmt.executeQuery(get_student)) {
                while(res.next()){
                    eStud.add(new HPair(res.getString("student_id"), res.getString("fname") + " " + res.getString("lname")));
                }
                res.close();
                stmt.close();
                con.close();
            }
        }
        return eStud;
    }
    ////////////////////////////////////////////////////////////////////////////
    public ArrayList<HPair> get_student_subjects(String student_id) throws SQLException{
        ArrayList<HPair> subjects= new ArrayList<>();
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String get_student = "select subject.sub_id, subject.sub_name "
                    + "from subject join enrolled_student on enrolled_student.subject_id = subject.sub_Id "
                    + "where enrolled_student.student_id= '" + student_id + "';";
            try (ResultSet res = stmt.executeQuery(get_student)) {
                while(res.next()){
                    subjects.add(new HPair(res.getString("sub_id"), res.getString("sub_name") ));
                }
                res.close();
                stmt.close();
                con.close();
            }
        }
        return subjects;
    }
    ////////////////////////////////////////////////////////////////////////////
    public ArrayList<String> get_student_w2besubjects(String student_id) throws SQLException{
        ArrayList<String> subjects= new ArrayList<>();
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String get_student = "select subject.sub_name from subject join waiting_2b_enrolled_student "
                    + "on waiting_2b_enrolled_student.subject_id = subject.sub_Id  "
                    + "where waiting_2b_enrolled_student.student_id= '" + student_id + "';";
            try (ResultSet res = stmt.executeQuery(get_student)) {
                while(res.next()){
                    subjects.add(res.getString("sub_name") );
                }
                res.close();
                stmt.close();
                con.close();
            }
        }
        return subjects;
    }
    ////////////////////////////////////////////////////////////////////////////
    public boolean is_student_enrolled(String student_id, String subject_id) throws SQLException{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String get_student = "select * from enrolled_student "
                    + "where enrolled_student.student_id = '" + student_id + "' "
                    + "and enrolled_student.subject_id = '" + subject_id + "';;";
            try (ResultSet res = stmt.executeQuery(get_student)) {
               if(res.next() ){
                   return true;
               }
                
                res.close();
                stmt.close();
                con.close();
            }
        }
        return false;
    }
    ////////////////////////////////////////////////////////////////////////////
    public String getIdbycodeandpass(String code, String pass) throws SQLException{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "SELECT sub_Id FROM grandmaster.subject "
                    + "where sub_Code = '" + code + "' and sub_pass = '" + pass + "';";
            try (ResultSet res = stmt.executeQuery(query)) {
                res.next();
                String result = res.getString("sub_Id");
                
                res.close();
                stmt.close();
                con.close();
                return result;
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////
    public void add_stud_to_waitinglist(String studId, String subId) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "insert into waiting_2b_enrolled_student values ('" + studId + "', '" + subId + "', '" + java.time.LocalDate.now() + "');";
            stmt.executeUpdate(query);
            
            stmt.close();
            con.close();
        }
    }
     ////////////////////////////////////////////////////////////////////////////
    public HPair get_code_and_pass_by_id(String id) throws SQLException{
        HPair reslut = new HPair();
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "SELECT sub_Code, sub_pass FROM grandmaster.subject "
                    + "where sub_Id = '" + id + "' ;";
            try (ResultSet res = stmt.executeQuery(query)) {
                res.next();
                reslut.setID(res.getString("sub_Code"));
                reslut.setDataA(res.getString("sub_pass"));
                
                res.close();
                stmt.close();
                con.close();
            }
        }
        return reslut;
    }
    ////////////////////////////////////////////////////////////////////////////
    
}

