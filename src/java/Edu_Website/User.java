package Edu_Website;


import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;


public class User extends Model{
    String fname, lname, username, password, gmail; 
    Number phone;
    
    /////////////////////////////////////////////////////////////////////////////////////////////////
    public String get_fname(){
        return this.fname;
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////
    public String get_lname(){
        return this.lname;
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////
    public String get_username(){
        return this.username;
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////
    public String get_gmail(){
        return this.gmail;
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////
    public int get_phone(){
        return Integer.parseInt(0 + this.phone.toString());
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////
    public String get_password(){
        return this.password;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    public void set_user(String fname, String lname, String username, String password, String gmail, int phone) throws Exception{
        this.fname = fname;
        this.lname = lname;
        this.username = username;
        this.password = password;
        this.gmail = gmail;
        this.phone = phone;
        
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
     public void get_user_data(String userID)throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = "select * FROM user where user_id = '" + userID + "';";
            try (ResultSet res = stmt.executeQuery(select_user)) {
                res.next();
                
                this.fname = res.getString("fname");
                this.lname = res.getString("lname");
                this.username = res.getString("username");
                this.password = res.getString("psswrd");
                this.phone = res.getInt("phone");
                this.gmail = res.getString("gmail");
                
                
                res.close();
                stmt.close();
                con.close();
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    public boolean update_user(String userid, String fname, String lname, String password, String gmail, Number phone)throws Exception{
        String query = "update user set fname = '" + fname + "', lname = '" + lname + "', "
                + "psswrd = '" + password + "', gmail = '" + gmail + "', phone = " + phone 
                + " where user_id = '" + userid + "';";
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
//            System.err.println("Query==> " + query);

            stmt.executeUpdate(query);
            stmt.close();
            con.close();
            
            return true;
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
//    public int delete_user(String username)throws Exception{
//        return 0;
//    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    public boolean isUserExist(String username, String password)throws Exception{
        return false;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    public boolean isuernameValid(String username) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = "select * FROM user where username = '" + username + "';";
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
    ////////////////////////////////////////////////////////////////////////////////////////////////
    public boolean isteachernameValid(String username) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = " select * FROM grandmaster.waiting_teacher where username = '" + username + "';";
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
    ////////////////////////////////////////////////////////////////////////////////////////////////
    public String get_user_id(String username) throws Exception{
         String result;
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = "select user_id FROM user where username = '" + username + "';";
            try (ResultSet res = stmt.executeQuery(select_user)) {
                res.next();
                result = res.getString("user_id");
                
                res.close();
                stmt.close();
                con.close();
                
            }
        }
        return result;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    public String getFullName(String id) throws Exception{
        String result;
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = "select fname, lname FROM user where user_id = '" + id + "';";
            try (ResultSet res = stmt.executeQuery(select_user)) {
                res.next();
                result = res.getString("fname") + " " + res.getString("lname");
                
                res.close();
                stmt.close();
                con.close();
                
            }
        }
        return result;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    public String get_user_type (String username) throws Exception{
        String result;
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String select_user = "select user_type FROM user where username = '" + username + "';";
            try (ResultSet res = stmt.executeQuery(select_user)) {
                res.next();
                result = res.getString("user_type");
                
                res.close();
                stmt.close();
                con.close();
                
            }
        }
        return result;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////////////////////
    
}
