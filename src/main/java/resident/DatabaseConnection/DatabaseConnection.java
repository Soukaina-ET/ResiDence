package resident.DatabaseConnection;

import java.sql.*;
import java.sql.DriverManager;

public class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/residence";
    private static final String USER = "root";
    private static final String PASSWORD = "Soukaina2003";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}

