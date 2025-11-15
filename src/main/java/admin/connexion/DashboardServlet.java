package admin.connexion;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private Connection getConnection() throws SQLException {
        String url = "jdbc:mysql://localhost:3306/residence";
        String user = "root";
        String password = "Soukaina2003";
        return DriverManager.getConnection(url, user, password);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");


    }
}
