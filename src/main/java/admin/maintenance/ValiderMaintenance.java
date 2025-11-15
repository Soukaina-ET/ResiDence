package admin.maintenance;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.*;
@WebServlet("/ValiderMaintenance")
public class ValiderMaintenance extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String maintenanceId = request.getParameter("id");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost/residence", "root", "Soukaina2003")) {
            // Définir le statut de la maintenance à "Terminé" et mettre la date de résolution
            String updateMaintenanceQuery = "UPDATE maintenance SET statut = 'Terminé', date_resolution = ? WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(updateMaintenanceQuery)) {
                ps.setTimestamp(1, new Timestamp(System.currentTimeMillis())); // Date et heure actuelles
                ps.setString(2, maintenanceId);
                ps.executeUpdate();
            }

            // Récupérer l'ID du résident et du technicien associés à cette maintenance
            String selectMaintenanceQuery = "SELECT resident_id, technicien_id FROM maintenance WHERE id = ?";
            int residentId = -1;
            int technicienId = -1;

            try (PreparedStatement ps = con.prepareStatement(selectMaintenanceQuery)) {
                ps.setString(1, maintenanceId);
                var rs = ps.executeQuery();
                if (rs.next()) {
                    residentId = rs.getInt("resident_id");
                    technicienId = rs.getInt("technicien_id");
                }
            }

            if (residentId != -1) {
                // Mettre à jour la disponibilité du résident à "disponible"
                String updateResidentQuery = "UPDATE resident SET disponibilite = 'disponible' WHERE id = ?";
                try (PreparedStatement ps = con.prepareStatement(updateResidentQuery)) {
                    ps.setInt(1, residentId);
                    ps.executeUpdate();
                }
            }

            if (technicienId != -1) {
                // Mettre à jour la disponibilité du technicien à "disponible"
                String updateTechnicienQuery = "UPDATE technicien SET disponibilite = 'disponible' WHERE id = ?";
                try (PreparedStatement ps = con.prepareStatement(updateTechnicienQuery)) {
                    ps.setInt(1, technicienId);
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Rediriger vers la page des maintenances
        response.sendRedirect("maintenance.jsp");
    }
}