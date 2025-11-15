package resident.maintenance;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import resident.DatabaseConnection.DatabaseConnection;
import java.io.IOException;
import java.sql.*;

@WebServlet("/MaintenanceServlet")
public class MaintenanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les données du formulaire
        String description = request.getParameter("description");

        // Récupérer l'ID du résident et de la chambre depuis la session
        HttpSession session = request.getSession();
        Integer residentId = (Integer) session.getAttribute("id");
        Integer chambreId = (Integer) session.getAttribute("chambre_id");

        if (residentId == null || chambreId == null) {
            request.setAttribute("errorMessage", "Session invalide. Veuillez vous reconnecter.");
            request.getRequestDispatcher("residentJsp/maintenanceResident.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Ajouter le signalement de maintenance
            String sql = "INSERT INTO maintenance (chambre_id, resident_id, description, statut, date_signalement) VALUES (?, ?, ?, 'En attente', NOW())";
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, chambreId);
                stmt.setInt(2, residentId);
                stmt.setString(3, description);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    // Récupérer l'ID du signalement inséré
                    ResultSet rs = stmt.getGeneratedKeys();
                    if (rs.next()) {
                        int maintenanceId = rs.getInt(1);

                        // Ajouter une notification pour l'administration
                        String notificationSql = "INSERT INTO notification (resident_id, message, date) VALUES (?, ?, NOW())";
                        try (PreparedStatement notificationStmt = conn.prepareStatement(notificationSql)) {
                            notificationStmt.setInt(1, residentId);
                            notificationStmt.setString(2, "Nouveau signalement de maintenance (#" + maintenanceId + ")");
                            notificationStmt.executeUpdate();
                        }

                        request.setAttribute("successMessage", "Signalement de maintenance ajouté avec succès.");
                    }
                } else {
                    request.setAttribute("errorMessage", "Erreur lors de l'ajout du signalement.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur s'est produite. Veuillez réessayer.");
        }

        // Rediriger vers la page de maintenance
        request.getRequestDispatcher("residentJsp/maintenanceResident.jsp").forward(request, response);
    }
}
