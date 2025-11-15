package resident.profil;




import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import resident.DatabaseConnection.DatabaseConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.*;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les données du formulaire
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Récupérer l'ID du résident depuis la session
        HttpSession session = request.getSession();
        Integer residentId = (Integer) session.getAttribute("id");

        if (residentId == null) {
            request.setAttribute("errorMessage", "Session invalide. Veuillez vous reconnecter.");
            request.getRequestDispatcher("residentJsp/parametreResident.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Les mots de passe ne correspondent pas.");
            request.getRequestDispatcher("residentJsp/parametreResident.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Vérifier le mot de passe actuel
            String sql = "SELECT password FROM resident WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, residentId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    String hashedPassword = rs.getString("password");
                    if (BCrypt.checkpw(currentPassword, hashedPassword)) {
                        // Hasher le nouveau mot de passe
                        String newHashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

                        // Mettre à jour le mot de passe dans la base de données
                        String updateSql = "UPDATE resident SET password = ? WHERE id = ?";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setString(1, newHashedPassword);
                            updateStmt.setInt(2, residentId);
                            updateStmt.executeUpdate();
                        }

                        request.setAttribute("successMessage", "Mot de passe mis à jour avec succès !");
                    } else {
                        request.setAttribute("errorMessage", "Mot de passe actuel incorrect.");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur s'est produite. Veuillez réessayer.");
        }

        // Rediriger vers la page des paramètres
        request.getRequestDispatcher("residentJsp/parametreResident.jsp").forward(request, response);
    }
}