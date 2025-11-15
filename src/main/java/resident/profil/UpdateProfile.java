package resident.profil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import resident.DatabaseConnection.DatabaseConnection;

import java.io.IOException;
import java.sql.*;

    @WebServlet("/UpdateProfilet")
    public class UpdateProfile extends HttpServlet {
        private static final long serialVersionUID = 1L;

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // Récupérer les données du formulaire
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String telephone = request.getParameter("telephone");
            String email = request.getParameter("email");

            // Récupérer l'ID du résident depuis la session
            HttpSession session = request.getSession();
            Integer residentId = (Integer) session.getAttribute("id");

            if (residentId == null) {
                request.setAttribute("errorMessage", "Session invalide. Veuillez vous reconnecter.");
                request.getRequestDispatcher("residentJsp/parametreResident.jsp").forward(request, response);
                return;
            }

            try (Connection conn = DatabaseConnection.getConnection()) {
                // Mettre à jour les informations dans la base de données
                String sql = "UPDATE resident SET nom = ?, prenom = ?, telephone = ?, email = ? WHERE id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, nom);
                    stmt.setString(2, prenom);
                    stmt.setString(3, telephone);
                    stmt.setString(4, email);
                    stmt.setInt(5, residentId);

                    int rowsUpdated = stmt.executeUpdate();
                    if (rowsUpdated > 0) {
                        // Mettre à jour la session avec les nouvelles informations
                        session.setAttribute("nom", nom);
                        session.setAttribute("prenom", prenom);
                        session.setAttribute("telephone", telephone);
                        session.setAttribute("email", email);

                        request.setAttribute("successMessage", "Profil mis à jour avec succès !");
                    } else {
                        request.setAttribute("errorMessage", "Erreur lors de la mise à jour du profil.");
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

