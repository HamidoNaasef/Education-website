package Edu_Website;


import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Notification extends Model{
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public ArrayList<HPair> get_teacher_notification(String teacherId) throws Exception{
        ArrayList<HPair> notifications = new ArrayList<>();
        String query_1 = "SELECT not_comment, Nrank "
                + "FROM grandmaster.notification "
                + "where notifire_id = '" + teacherId + "';";
        String query_2 = "select not_comment, sub_Id, Nrank "
                + "from (subject join notification on sub_Id = notifire_id) "
                + "where supervisorId = '" + teacherId + "';";
        
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            try (ResultSet res = stmt.executeQuery(query_1)) {
                while(res.next()){
                    notifications.add(new HPair(res.getString("Nrank"), res.getString("not_comment")));
                }
                
                res.close();
            }
            try (ResultSet res2 = stmt.executeQuery(query_2)){
                while(res2.next()){
                    notifications.add(new HPair(res2.getString("Nrank"), res2.getString("not_comment"), res2.getString("sub_Id")));
                }
                res2.close();
            }
            
            stmt.close();
            con.close();
        }        
        HPair hp = new HPair();
        return hp.sortByRank(notifications);
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public ArrayList<HPair> get_student_notification(String student_id) throws Exception{
        ArrayList<HPair> notifications = new ArrayList<>();
        String query_1 = "SELECT not_comment, Nrank "
                + "FROM grandmaster.notification "
                + "where notifire_id = '" + student_id + "';";
        String query_2 = "select not_comment, subject_id, Nrank "
                + "from notification join enrolled_student "
                + "on notification.notifire_id = enrolled_student.subject_id "
                + "where enrolled_student.student_id = '" + student_id + "';";
        
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            try (ResultSet res = stmt.executeQuery(query_1)) {
                while(res.next()){
                    notifications.add(new HPair(res.getString("Nrank"), res.getString("not_comment")));
                }
                
                res.close();
            }
            try (ResultSet res2 = stmt.executeQuery(query_2)){
                while(res2.next()){
                    notifications.add(new HPair(res2.getString("Nrank"), res2.getString("not_comment"), res2.getString("subject_id")));
                }
                res2.close();
            }
            
            stmt.close();
            con.close();
        }        
        HPair hp = new HPair();
        return hp.sortByRank(notifications);
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public void insert_notification(String not_comment, String id) throws SQLException{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String countQuery = "SELECT count(*) as numOfNoti FROM grandmaster.notification;";
            String query;         
            try (Statement stmt2 = con.createStatement();ResultSet count_res = stmt.executeQuery(countQuery)) {
                count_res.next();
                int count = count_res.getInt("numOfNoti") +1;
                query = "insert into grandmaster.notification (not_id, not_comment, notifire_id) "
                    + "values('not-" + count + "', '" + not_comment + "', '" + id + "');";
                
                count_res.close();
                stmt2.executeUpdate(query);
                stmt2.close();
            }
            
            stmt.close();
            con.close();
        }
    
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
}
