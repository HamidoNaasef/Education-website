package Edu_Website;


import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class Student extends User{
    
    
    
  /////////////////////////////////////////////////////////////////////////////////////////////////
//    @Override
//    public ResultSet select_user(String username, String password)throws Exception{
//        Connection con = this.connection.connect();
//        Statement stmt = con.createStatement();
//        String select_user = "select * FROM user where username like '" + username + "' and psswrd like '" + password + "';";
//        ResultSet res = stmt.executeQuery(select_user);
//        res.next();
//        
//        
//        //System.err.println("");
//        stmt.close();
//        con.close();
//        return res;
//    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    public int insert_user(String fname, String lname, String username, String password, String gmail, String phone) throws Exception{
        int res;               
        String userid = "s-" + java.time.LocalDate.now() + "-";
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String count_user = "select count(user_id) as numOfStud FROM user where user_type like 'stud';";
            String insert_user;
            // get the number of user
            try (Statement stmt2 = con.createStatement();ResultSet temp_res = stmt.executeQuery(count_user)) {
              
                temp_res.next();
                int temp_int;
                temp_int = temp_res.getInt("numOfStud");
                temp_int++;
                userid = userid + temp_int;
                                
                insert_user = "INSERT INTO user VALUES ('" + userid + "', '" + fname + "', '" + lname +"', '" + username + "', '" +
                    password + "', '"+ gmail +"', "+ Integer.parseInt(phone) +" , 'stud'); ";
                res = stmt2.executeUpdate(insert_user);
                
                temp_res.close();
                stmt.close();
                stmt2.close();
                System.out.println("result ==>" + res);
            }
            con.close();
        }
        return res;
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    @Override
    public boolean isUserExist(String username, String password)throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = "select * FROM user where username like '" + username + "' and psswrd like '" + password + "' and user_type like 'stud';";
            try (ResultSet res = stmt.executeQuery(select_user)) {
                if(res.next()){
                    res.close();
                    stmt.close();
                    con.close();
                    return true;
                }
            }
            stmt.close();
            con.close();
        }
        return false;
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
}