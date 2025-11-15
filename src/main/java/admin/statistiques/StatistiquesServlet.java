package admin.statistiques;


import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import org.json.JSONObject;

@WebServlet("/StatistiquesServlet")
public class StatistiquesServlet extends HttpServlet {
    private Connection getConnection() throws SQLException {
        String url = "jdbc:mysql://localhost:3306/residence";
        String user = "root";
        String password = "Soukaina2003";
        return DriverManager.getConnection(url, user, password);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        // Objet JSON pour stocker les statistiques
        JsonObject json = new JsonObject();

        try (Connection conn = getConnection()) {
            // Chambres
            JsonObject chambres = new JsonObject();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT statut, COUNT(*) as count FROM chambre GROUP BY statut")) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    chambres.addProperty(rs.getString("statut"), rs.getInt("count"));
                }
            }
            json.add("chambres", chambres);

            // Résidents
            JsonObject residents = new JsonObject();
            try (PreparedStatement psTotal = conn.prepareStatement("SELECT COUNT(*) as count FROM resident");
                 PreparedStatement psNouveaux = conn.prepareStatement(
                         "SELECT COUNT(*) as count FROM resident WHERE DATE(date_demande) >= CURDATE() - INTERVAL 30 DAY")) {
                ResultSet rsTotal = psTotal.executeQuery();
                if (rsTotal.next()) {
                    residents.addProperty("Total", rsTotal.getInt("count"));
                }
                ResultSet rsNouveaux = psNouveaux.executeQuery();
                if (rsNouveaux.next()) {
                    residents.addProperty("Nouveaux", rsNouveaux.getInt("count"));
                    residents.addProperty("Ancien", residents.get("Total").getAsInt() - rsNouveaux.getInt("count"));
                }
            }
            json.add("residents", residents);


            // Paiements
            JsonObject paiements = new JsonObject();
            try (PreparedStatement psDue = conn.prepareStatement(
                    "SELECT SUM(montant_due) as total_due FROM paiements WHERE statut = 'En attente'");
                 PreparedStatement psPaid = conn.prepareStatement(
                         "SELECT SUM(montant_paye) as total_paid FROM paiements WHERE statut = 'Payé'")) {
                ResultSet rsDue = psDue.executeQuery();
                if (rsDue.next()) {
                    paiements.addProperty("Montant dû", rsDue.getDouble("total_due"));
                } else {
                    paiements.addProperty("Montant dû", 0);
                }

                ResultSet rsPaid = psPaid.executeQuery();
                if (rsPaid.next()) {
                    paiements.addProperty("Payé", rsPaid.getDouble("total_paid"));
                    paiements.addProperty("En attente",
                            paiements.get("Montant dû").getAsDouble() - rsPaid.getDouble("total_paid"));
                } else {
                    paiements.addProperty("Payé", 0);
                    paiements.addProperty("En attente", paiements.get("Montant dû").getAsDouble());
                }
            }
            json.add("paiements", paiements);


            // Maintenance
            JsonObject maintenance = new JsonObject();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT statut, COUNT(*) as count FROM maintenance GROUP BY statut")) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    maintenance.addProperty(rs.getString("statut"), rs.getInt("count"));
                }
                if (!rs.isBeforeFirst()) {
                    maintenance.addProperty("Aucune donnée", 0);
                }
            }
            json.add("maintenance", maintenance);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            json.addProperty("error", "Erreur lors de la récupération des statistiques.");
        }

        // Envoi des données JSON
        resp.getWriter().write(json.toString());
    }
}
