package resident.inscription;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.mindrot.jbcrypt.BCrypt;
import resident.DatabaseConnection.DatabaseConnection;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


/**
 * Servlet implementation class InscriptionServlet
 */
@WebServlet("/InscriptionServlet")
@MultipartConfig
public class InscriptionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les données du formulaire
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String password = request.getParameter("password");
        String cne = request.getParameter("cne");
        Part carteEtudiante = request.getPart("carte_etudiante");

        // Validation des champs
        if (nom == null || nom.isEmpty() ||
                prenom == null || prenom.isEmpty() ||
                email == null || !email.matches("[^@\\s]+@[^@\\s]+\\.[^@\\s]+") ||
                telephone == null || !telephone.matches("\\d{10}") ||
                password == null || password.isEmpty() ||
                cne == null || cne.length() != 10) {
            request.setAttribute("errorMessage", "Certains champs sont invalides ou manquants.");
            request.getRequestDispatcher("Confirmation.jsp").forward(request, response);
            return;
        }

        if (carteEtudiante.getSize() > 10485760) { // Limite à 10 Mo
            request.setAttribute("errorMessage", "La carte étudiante est trop volumineuse. Taille maximale : 10 Mo.");
            request.getRequestDispatcher("Confirmation.jsp").forward(request, response);
            return;
        }

        if (carteEtudiante.getSize() == 0) {
            request.setAttribute("errorMessage", "Le fichier de la carte étudiante est vide.");
            request.getRequestDispatcher("Confirmation.jsp").forward(request, response);
            return;
        }

        // Connexion à la base de données
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Préparation de la requête SQL
            String sql = "INSERT INTO demandes_inscription (nom, prenom, email, telephone, password, cne, carte_etudiante) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, nom);
                stmt.setString(2, prenom);
                stmt.setString(3, email);
                stmt.setString(4, telephone);
                stmt.setString(5, hashPassword(password)); // Hash du mot de passe
                stmt.setString(6, cne);

                // Ajouter le fichier de la carte étudiante
                InputStream inputStream = carteEtudiante.getInputStream();
                stmt.setBlob(7, inputStream);

                // Exécuter la requête
                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    request.setAttribute("successMessage", "L'inscription est réussie. Attendez votre e-mail de confirmation après la révision de votre demande.");
                } else {
                    request.setAttribute("errorMessage", "Votre inscription a échoué.");
                }
                request.getRequestDispatcher("Confirmation.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur s'est produite, veuillez réessayer.");
            request.getRequestDispatcher("Confirmation.jsp").forward(request, response);
        }
    }

    // Méthode pour hasher les mots de passe
    private String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }
}