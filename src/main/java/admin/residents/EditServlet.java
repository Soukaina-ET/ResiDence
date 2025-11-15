package admin.residents;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Servlet implementation class ModificationServlet
 */
@MultipartConfig
@WebServlet("/EditServlet")
public class EditServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // La méthode GET ne sera probablement pas utilisée ici
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method not supported for this request.");
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les paramètres du formulaire
        String residentId = request.getParameter("id");

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String cne = request.getParameter("cne");
        // Générer la date actuelle
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateDemande = formatter.format(new Date());
        // Vérifier si chambre_id est fourni, sinon le définir à NULL
        String chambreId = request.getParameter("chambre_id");
        if (chambreId == null || chambreId.isEmpty()) {
            chambreId = null;  // Attribuer NULL si chambre_id n'est pas spécifié
        }

        // Récupérer l'image de la carte d'étudiant
        Part carteEtudiantePart = request.getPart("carte_etudiante");
        InputStream carteEtudianteInputStream = carteEtudiantePart.getInputStream();

        // Connexion à la base de données
        String url = "jdbc:mysql://localhost/residence";
        String driver = "com.mysql.cj.jdbc.Driver";
        try {
            Class.forName(driver);

        try (Connection con = DriverManager.getConnection(url, "root", "Soukaina2003")) {
            String sql = "UPDATE resident\n" +
                    "SET nom = ?, prenom = ?, email = ?, telephone = ?, cne = ?, carte_etudiante = ?, date_demande = ?, chambre_id = ?\n" +
                    "WHERE id = ?;\n";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, nom);
                ps.setString(2, prenom);
                ps.setString(3, email);
                ps.setString(4, telephone);
                ps.setString(5, cne);
                ps.setBlob(6, carteEtudianteInputStream);
                ps.setString(7, dateDemande);
                ps.setObject(8, chambreId);  // Utiliser setObject pour gérer NULL pour chambre_id
                ps.setString(9,residentId);
                int result = ps.executeUpdate();
                if (result > 0) {
                    // Si chambre_id est renseigné, mettre à jour le statut de la chambre
                    if (chambreId != null) {
                        String updateChambreSql = "UPDATE chambre SET statut = 'occupée' WHERE id = ?";
                        try (PreparedStatement updatePs = con.prepareStatement(updateChambreSql)) {
                            updatePs.setString(1, chambreId);
                            updatePs.executeUpdate();
                        }
                    }
                    response.sendRedirect("residents.jsp");
                } else {
                    response.getWriter().println("Erreur lors de l'insertion des données.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Erreur de connexion à la base de données : " + e.getMessage());
        }
        } catch (ClassNotFoundException e) {
        throw new RuntimeException(e);
    }
    }
}