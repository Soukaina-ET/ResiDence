package admin.technicien;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;
import java.io.IOException;

@WebServlet("/SupprimerTechnicien")
public class SupprimerTechnicien extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String telephone = request.getParameter("telephone");
        String email = request.getParameter("email");
        String disponibilite = request.getParameter("disponibilite");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost/residence", "root", "Soukaina2003")) {
            String query = "UPDATE technicien SET nom=?, prenom=?, telephone=?, email=?, disponibilite=? WHERE id=?";
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setString(1, nom);
                ps.setString(2, prenom);
                ps.setString(3, telephone);
                ps.setString(4, email);
                ps.setString(5, disponibilite);
                ps.setInt(6, id);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("technicien.jsp");
    }
}

