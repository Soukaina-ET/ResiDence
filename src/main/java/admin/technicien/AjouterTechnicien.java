package admin.technicien;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/AjouterTechnicien")
public class AjouterTechnicien extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String telephone = request.getParameter("telephone");
        String email = request.getParameter("email");
        String cnie = request.getParameter("cnie");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost/residence", "root", "Soukaina2003")) {
            String query = "INSERT INTO technicien (nom, prenom, telephone, email, cnie, disponibilite) VALUES (?, ?, ?, ?, ?, 'Disponible')";
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setString(1, nom);
                ps.setString(2, prenom);
                ps.setString(3, telephone);
                ps.setString(4, email);
                ps.setString(5, cnie);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("technicien.jsp");
    }
}

