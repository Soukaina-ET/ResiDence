package admin.notification;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONArray;
import org.json.JSONObject;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/NotificationsServlet")
public class NotificationsServlets extends HttpServlet {

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/residence", "root", "Soukaina2003"
        );
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Integer residentId = (Integer) session.getAttribute("id");

        if (residentId == null) {
            response.sendRedirect(request.getContextPath() + "/loginResident.jsp");
            return;
        }

        try {
            switch (action == null ? "" : action) {
                case "markAsRead":
                    markNotificationAsRead(request, response);
                    break;

                case "markAllAsRead":
                    markAllNotificationsAsRead(response, residentId);
                    break;

                case "delete":
                    deleteNotification(request, response);
                    break;

                case "getCount":
                    getUnreadCount(response, residentId);
                    break;

                case "getAll":
                    getAllNotifications(response, residentId);
                    break;

                default:
                    request.setAttribute("residentId", residentId);
                    request.getRequestDispatcher("/notifications.jsp").forward(request, response);
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500, "Erreur serveur");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // ---- ACTIONS ----

    private void markNotificationAsRead(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = getConnection()) {
            String sql = "UPDATE notification SET status = 'read' WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                int rows = stmt.executeUpdate();

                JSONObject json = new JSONObject();
                json.put("success", rows > 0);
                json.put("message", rows > 0 ? "Notification lue" : "Notification introuvable");

                sendJson(response, json);
            }
        }
    }

    private void markAllNotificationsAsRead(HttpServletResponse response, int residentId)
            throws SQLException, IOException {

        try (Connection conn = getConnection()) {
            String sql = "UPDATE notification SET status = 'read' WHERE resident_id = ? AND status = 'unread'";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, residentId);
                int rows = stmt.executeUpdate();

                JSONObject json = new JSONObject();
                json.put("success", true);
                json.put("count", rows);
                json.put("message", rows + " notification(s) marquée(s) comme lue(s)");

                sendJson(response, json);
            }
        }
    }

    private void deleteNotification(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = getConnection()) {
            String sql = "DELETE FROM notification WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                int rows = stmt.executeUpdate();

                JSONObject json = new JSONObject();
                json.put("success", rows > 0);
                json.put("message", rows > 0 ? "Supprimée" : "Introuvable");

                sendJson(response, json);
            }
        }
    }

    private void getUnreadCount(HttpServletResponse response, int residentId)
            throws SQLException, IOException {

        try (Connection conn = getConnection()) {
            String sql = "SELECT COUNT(*) AS count FROM notification WHERE resident_id = ? AND status = 'unread'";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, residentId);
                ResultSet rs = stmt.executeQuery();
                rs.next();

                JSONObject json = new JSONObject();
                json.put("count", rs.getInt("count"));

                sendJson(response, json);
            }
        }
    }

    private void getAllNotifications(HttpServletResponse response, int residentId)
            throws SQLException, IOException {

        try (Connection conn = getConnection()) {
            String sql = """
                SELECT id, message, status, created_at
                FROM notification
                WHERE resident_id = ?
                ORDER BY created_at DESC
                """;

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, residentId);
                ResultSet rs = stmt.executeQuery();

                JSONArray list = new JSONArray();

                while (rs.next()) {
                    JSONObject n = new JSONObject();
                    n.put("id", rs.getInt("id"));
                    n.put("message", rs.getString("message"));
                    n.put("status", rs.getString("status"));
                    n.put("created_at", rs.getTimestamp("created_at").toString());
                    list.put(n);
                }

                JSONObject json = new JSONObject();
                json.put("notifications", list);
                json.put("total", list.length());

                sendJson(response, json);
            }
        }
    }

    // ---- UTIL ----

    private void sendJson(HttpServletResponse response, JSONObject json)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(json.toString());
        out.flush();
    }

    public static void createNotification(Connection conn, int residentId, String message)
            throws SQLException {

        String sql = "INSERT INTO notification (resident_id, message, status, created_at) VALUES (?, ?, 'unread', NOW())";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, residentId);
            stmt.setString(2, message);
            stmt.executeUpdate();
        }
    }

    public static void createNotificationForAll(Connection conn, String message)
            throws SQLException {

        String sql = "INSERT INTO notification (resident_id, message, status, created_at) SELECT id, ?, 'unread', NOW() FROM resident";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, message);
            stmt.executeUpdate();
        }
    }
}
