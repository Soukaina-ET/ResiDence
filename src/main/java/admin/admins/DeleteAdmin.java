package admin.admins;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.sql.*;

@WebServlet("/DeleteAdmin")
public class DeleteAdmin extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");

        // Connexion à la base de données et suppression
        String url = "jdbc:mysql://localhost/residence";
        String driver = "com.mysql.cj.jdbc.Driver";
        try {
            Class.forName(driver);
            Connection con = DriverManager.getConnection(url, "root", "Soukaina2003");

            String query = "DELETE FROM admin WHERE id = ?";
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, Integer.parseInt(id));

            int result = stmt.executeUpdate();
            if (result > 0) {
                response.sendRedirect("admins.jsp");
            } else {
                response.getWriter().println("Erreur lors de la suppression de l'admin");
            }

            stmt.close();
            con.close();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("Erreur de connexion à la base de données : " + e.getMessage());
        }
    }
}

