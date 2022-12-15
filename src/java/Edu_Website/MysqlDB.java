package Edu_Website;


import com.mysql.jdbc.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class MysqlDB extends DBConnection{
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public MysqlDB() {
        this.url = "jdbc:mysql://localhost:3306/grandmaster";
        this.userName = "root";
        this.password = "root";
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @Override
    public Connection connect (){
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con=(Connection) DriverManager.getConnection(this.url, this.userName, this.password);
            return con;

        } catch (ClassNotFoundException | SQLException cnfe) {
            System.err.println("database not working");
        }
        
        return null;
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
