package admin.paiement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/getPaiementDetails")
public class getPaiementDetails extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        // Vérification de la présence et de la validité du paramètre
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de paiement manquant.");
            return;  // Exit the method if the ID is invalid
        }

        int paiementId;
        try {
            paiementId = Integer.parseInt(idParam); // Try parsing the ID
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de paiement invalide.");
            return;  // Exit the method if the ID is not a valid number
        }

        // Variables pour stocker les détails du paiement
        int residentId = 0;
        int chambreId = 0;
        double montantDue = 0.0;
        double montantPaye = 0.0;
        String modePaiement = "";
        String commentaire = "";

        // Connexion à la base de données et récupération des données
        String url = "jdbc:mysql://localhost/residence"; // Modifier avec vos infos de connexion
        String user = "root"; // Modifier avec votre utilisateur
        String password = "password"; // Modifier avec votre mot de passe

        String query = "SELECT * FROM paiements WHERE id = ?"; // Requête pour récupérer le paiement

        try (Connection con = DriverManager.getConnection(url, user, password);
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, paiementId); // Paramétrer l'ID dans la requête

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Récupérer les détails du paiement
                    residentId = rs.getInt("resident_id");
                    chambreId = rs.getInt("chambre_id");
                    montantDue = rs.getDouble("montant_due");
                    montantPaye = rs.getDouble("montant_paye");
                    modePaiement = rs.getString("mode_paiement");
                    commentaire = rs.getString("commentaire");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Définir les attributs pour les utiliser dans la page JSP ou répondre avec un JSON
        request.setAttribute("resident_id", residentId);
        request.setAttribute("chambre_id", chambreId);
        request.setAttribute("montant_due", montantDue);
        request.setAttribute("montant_paye", montantPaye);
        request.setAttribute("isEspèceSelected", "Espèce".equals(modePaiement));
        request.setAttribute("isEspèceSelected", "Carte".equals(modePaiement));
        request.setAttribute("commentaire", commentaire);

        // Retourner la page ou répondre avec un format JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            String json = "{"
                    + "\"resident_id\": \"" + residentId + "\","
                    + "\"chambre_id\": \"" + chambreId + "\","
                    + "\"montant_due\": \"" + montantDue + "\","
                    + "\"montant_paye\": \"" + montantPaye + "\","
                    + "\"mode_paiement\": \"" + modePaiement + "\","
                    + "\"commentaire\": \"" + commentaire + "\""
                    + "}";

            out.write(json);
            out.flush();
        } catch (IOException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors de la génération de la réponse.");
        }

    }
   @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
   }
}

