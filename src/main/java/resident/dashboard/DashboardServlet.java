package resident.dashboard;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONArray;
import org.json.JSONObject;
import resident.DatabaseConnection.DatabaseConnection;

import java.io.IOException;
import java.sql.*;

@WebServlet("/ResidentDashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Integer residentId = (Integer) session.getAttribute("id");

        if (residentId == null) {
            response.sendRedirect(request.getContextPath() + "/FormulaireConnexion.jsp");
            return;
        }

        JSONObject jsonResponse = new JSONObject();

        try (Connection conn = DatabaseConnection.getConnection()) {
            if (action == null) {
                // Récupérer les statistiques
                int pendingPayments = getPendingPayments(conn, residentId);
                int maintenanceRequests = getMaintenanceRequests(conn, residentId);
                int unreadNotifications = getUnreadNotifications(conn, residentId);

                jsonResponse.put("pendingPayments", pendingPayments);
                jsonResponse.put("maintenanceRequests", maintenanceRequests);
                jsonResponse.put("unreadNotifications", unreadNotifications);
            } else if ("recentPayments".equals(action)) {
                // Récupérer les derniers paiements
                JSONArray recentPayments = getRecentPayments(conn, residentId);
                jsonResponse.put("data", recentPayments);
            } else if ("recentMaintenance".equals(action)) {
                // Récupérer les derniers signalements de maintenance
                JSONArray recentMaintenance = getRecentMaintenance(conn, residentId);
                jsonResponse.put("data", recentMaintenance);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            jsonResponse.put("error", "Une erreur s'est produite.");
        }

        response.setContentType("application/json");
        response.getWriter().write(jsonResponse.toString());
    }

    private int getPendingPayments(Connection conn, int residentId) throws SQLException {
        String sql = "SELECT COUNT(*) AS count FROM paiements WHERE resident_id = ? AND statut = 'En attente'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, residentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }

    private int getMaintenanceRequests(Connection conn, int residentId) throws SQLException {
        String sql = "SELECT COUNT(*) AS count FROM maintenance WHERE resident_id = ? AND statut = 'En attente'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, residentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }

    private int getUnreadNotifications(Connection conn, int residentId) throws SQLException {
        String sql = "SELECT COUNT(*) AS count FROM notification WHERE resident_id = ? AND status = 'unread'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, residentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }

    private JSONArray getRecentPayments(Connection conn, int residentId) throws SQLException {
        JSONArray payments = new JSONArray();
        String sql = "SELECT id, montant, date_paiement AS date, statut FROM paiements WHERE resident_id = ? ORDER BY date_paiement DESC LIMIT 5";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, residentId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                JSONObject payment = new JSONObject();
                payment.put("id", rs.getInt("id"));
                payment.put("montant", rs.getDouble("montant"));
                payment.put("date", rs.getTimestamp("date").toString());
                payment.put("statut", rs.getString("statut"));
                payments.put(payment);
            }
        }
        return payments;
    }

    private JSONArray getRecentMaintenance(Connection conn, int residentId) throws SQLException {
        JSONArray maintenance = new JSONArray();
        String sql = "SELECT id, description, date_signalement AS date, statut FROM maintenance WHERE resident_id = ? ORDER BY date_signalement DESC LIMIT 5";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, residentId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                JSONObject request = new JSONObject();
                request.put("id", rs.getInt("id"));
                request.put("description", rs.getString("description"));
                request.put("date", rs.getTimestamp("date").toString());
                request.put("statut", rs.getString("statut"));
                maintenance.put(request);
            }
        }
        return maintenance;
    }
}
