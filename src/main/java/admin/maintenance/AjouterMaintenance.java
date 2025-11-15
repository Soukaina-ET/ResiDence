package admin.maintenance;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
@WebServlet("/AjouterMaintenance")
public class AjouterMaintenance extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String chambreId = request.getParameter("chambreId");
            String residentId = request.getParameter("residentId");
            String description = request.getParameter("description");
            String technicienId = request.getParameter("technicienId");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost/residence", "root", "Soukaina2003");
            String query = "INSERT INTO maintenance (chambre_id, resident_id, description, technicien_id, statut) VALUES (?, ?, ?, ?, 'En attente')";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(chambreId));
            ps.setInt(2, Integer.parseInt(residentId));
            ps.setString(3, description);
            ps.setInt(4, Integer.parseInt(technicienId));
            ps.executeUpdate();

            response.sendRedirect("maintenance.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Erreur : " + e.getMessage());
        }
    }
}

