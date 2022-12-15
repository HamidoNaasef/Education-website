package Edu_Website;


import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;


public class Teacher extends User{
    /////////////////////////////////////////////////////////////////////////////////////////////////
    public int insert_user(String fname, String lname, String username, String password, String gmail, String phone) throws Exception{
        int res;               
        String userid = "t-" + java.time.LocalDate.now() + "-";
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String count_user = "select count(user_id) as numOfStud FROM user where user_type like 'teach';";
            String insert_user;
            // get the number of user
            try (Statement stmt2 = con.createStatement();ResultSet temp_res = stmt.executeQuery(count_user)) {
              
                temp_res.next();
                int temp_int;
                temp_int = temp_res.getInt("numOfStud");
                temp_int++;
                userid = userid + temp_int;
                
                // inserting teacher to DB
                insert_user = "INSERT INTO user VALUES ('" + userid + "', '" + fname + "', '" + lname +"', '" + username + "', '" +
                    password + "', '"+ gmail +"', "+ Integer.parseInt(phone) +" , 'teach'); ";
                res = stmt2.executeUpdate(insert_user);
                
                temp_res.close();
                stmt.close();
                stmt2.close();
            }
            con.close();
        }
        return res;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    public void adding_teacher_to_waiting_list(String fname, String lname, String username, String password, String gmail, String phone)throws Exception{
        
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String count_user = "SELECT count(teacher_id) as numOfStud FROM grandmaster.waiting_teacher;";
            
            
            // get the number of user
            try (Statement stmt2 = con.createStatement();ResultSet res2 = stmt.executeQuery(count_user)) {
              
                res2.next();
                int WTcounter = res2.getInt("numOfStud");
                WTcounter++;
                String waiting_teacher_id = "wt-" + java.time.LocalDate.now() + "-" + WTcounter;
                
                // inserting teacher to DB
                
                String query = "INSERT INTO grandmaster.waiting_teacher VALUES ('" + waiting_teacher_id + "', '" + fname + "', '" + lname +"', '" + username + "', '" +
                    password + "', '"+ gmail +"', "+ Integer.parseInt(phone) +"); ";
                
                stmt2.executeUpdate(query);
                
                res2.close();
                stmt.close();
                stmt2.close();
            }
            con.close();
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    @Override
    public boolean isUserExist(String username, String password)throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = "select * FROM user where username like '" + username + "' and psswrd like '" + password + "' and user_type like 'teach';";
            try (ResultSet res = stmt.executeQuery(select_user)) {
                if(res.next()){
                    return true;
                }
            }
            stmt.close();
            con.close();
        }
        return false;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    public ArrayList<HPair> getTeacherSubjects(String TeacherId) throws Exception{
        ArrayList<HPair> subjects = new ArrayList<>();
        String query = "select sub_Id, sub_name from subject where supervisorId = '" + TeacherId + "';";
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement(); ResultSet res = stmt.executeQuery(query)) {
            while(res.next()){
                subjects.add(new HPair(res.getString("sub_Id"), res.getString("sub_name")));
            }
            stmt.close();
            con.close();
        }catch(Exception er){
            System.err.println("==> Error in getting subjects");
        }
        
        return subjects;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    public User getTeacherFromWAitingQueue(String id) throws SQLException, Exception{
        User teacher = new User();
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = "select * FROM grandmaster.waiting_teacher where teacher_id = '" + id + "';";
            try (ResultSet res = stmt.executeQuery(select_user)) {
                res.next();
                
                teacher.set_user( res.getString("fname"), res.getString("lname"),
                        res.getString("username"), res.getString("password"),
                        res.getString("gmail"), res.getInt("phone"));
                
                res.close();
                stmt.close();
                con.close();
                
            }
        }
        return teacher;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    public ArrayList<HPair> get_waiting_teacher_for_admin() throws Exception{
        ArrayList<HPair> waiting_teachers = new ArrayList<>();
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = "select * FROM grandmaster.waiting_teacher;";
            try (ResultSet res = stmt.executeQuery(select_user)) {
                res.next();
                // HPair(id, fullname)
                
                waiting_teachers.add(new HPair(res.getString("teacher_id"), res.getString("fname") + " " + res.getString("lname")));
                
                
                res.close();
                stmt.close();
                con.close();
                
            }
        }
        return waiting_teachers;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    public void removeTeacherFromWaitingList(String teacherId) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "delete from grandmaster.waiting_teacher where teacher_id = '" + teacherId + "';";
            int res = stmt.executeUpdate(query);
            
            stmt.close();
            con.close();
        }catch(Exception rtfwl){
            System.err.println("Hint: Deleting teacher isn't working!!");
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    public User getWaitingTeacherData(String teacherId) throws Exception{
        User teacher = new Teacher();
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String get_teacher = "select * from grandmaster.waiting_teacher where teacher_id = '" + teacherId + "';";
            try(ResultSet res = stmt.executeQuery(get_teacher)){
                if(res.next()){
                    teacher.set_user(res.getString("fname"), res.getString("lname"), res.getString("username")
                            , res.getString("psswrd"), res.getString("gmail"), res.getInt("phone"));
                }else{
                    System.err.println("Hint: no waiting teacher in database!!");
                }
                res.close();
                stmt.close();
                con.close();
            }
        }catch(Exception rtfwl){
            System.err.println("Hint: Deleting teacher isn't working!!");
        }
        return teacher;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
}


