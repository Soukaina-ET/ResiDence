package resident.profil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.*;
import resident.DatabaseConnection.DatabaseConnection;

@WebServlet("/UpdateProfileServlet")
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, IOException {
        // Récupérer les données du formulaire
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String telephone = request.getParameter("telephone");
        String email = request.getParameter("email");
        Part profileImagePart = request.getPart("profile_image");

        // Récupérer l'ID du résident depuis la session
        HttpSession session = request.getSession();
        Integer residentId = (Integer) session.getAttribute("id");

        if (residentId == null) {
            response.sendRedirect(request.getContextPath() + "/loginResident.jsp");
            return;
        }

        // Chemin pour stocker l'image de profil
        String uploadPath = getServletContext().getRealPath("/profileImages");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String profileImageName = null;
        if (profileImagePart != null && profileImagePart.getSize() > 0) {
            profileImageName = Paths.get(profileImagePart.getSubmittedFileName()).getFileName().toString();
            try (InputStream input = profileImagePart.getInputStream()) {
                Files.copy(input, Paths.get(uploadPath, profileImageName), StandardCopyOption.REPLACE_EXISTING);
            }
        }

        // Mettre à jour les informations dans la base de données
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "UPDATE resident SET nom = ?, prenom = ?, telephone = ?, email = ?, profile_image = ? WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, nom);
                stmt.setString(2, prenom);
                stmt.setString(3, telephone);
                stmt.setString(4, email);
                stmt.setString(5, profileImageName);
                stmt.setInt(6, residentId);

                int rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    // Mettre à jour la session avec les nouvelles informations
                    session.setAttribute("nom", nom);
                    session.setAttribute("prenom", prenom);
                    session.setAttribute("telephone", telephone);
                    session.setAttribute("email", email);
                    if (profileImageName != null) {
                        session.setAttribute("profile_image", profileImageName);
                    }

                    request.setAttribute("successMessage", "Profil mis à jour avec succès !");
                } else {
                    request.setAttribute("errorMessage", "Erreur lors de la mise à jour du profil.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur s'est produite. Veuillez réessayer.");
        }

        // Rediriger vers la page de profil
        request.getRequestDispatcher("/residentJsp/profilResident.jsp").forward(request, response);
    }
}