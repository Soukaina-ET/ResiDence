package admin.maintenance;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.*;

@WebServlet("/ModifierMaintenance")
public class ModifierMaintenance extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // La méthode GET ne sera probablement pas utilisée ici
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method not supported for this request.");
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Récupération des paramètres
        String fid = request.getParameter("id");
        System.out.println("ID reçu : " + fid);
        if (fid == null || fid.isEmpty()) {
            response.getWriter().println("<h3>Erreur : L'ID est manquant.</h3>");
            return;
        }
        String fchambre_id = request.getParameter("chambre_id");
        String fresident_id = request.getParameter("resident_id");
        String fdescription = request.getParameter("description");
        String fstatut = request.getParameter("statut");
        String ftechnicien_id= request.getParameter("technicien_id");

        // Connexion à la base de données
        String url = "jdbc:mysql://localhost/residence";
        String driver = "com.mysql.cj.jdbc.Driver";
        try (Connection con = DriverManager.getConnection(url, "root", "Soukaina2003");
             PreparedStatement pstmt = con.prepareStatement("UPDATE maintenance SET chambre_id = ?, resident_id = ?, description = ?, statut = ?, technicien_id = ? WHERE id = ?");) {
            System.out.println("Requête SQL exécutée : UPDATE chambre SET ... WHERE id = " + fid);
            pstmt.setString(1, fchambre_id);
            pstmt.setString(2, fresident_id);
            pstmt.setString(3, fdescription);
            pstmt.setString(4, fstatut);
            pstmt.setString(5, ftechnicien_id);
            pstmt.setString(6, fid);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("maintenance.jsp"); // Redirection en cas de succès
            } else {
                response.getWriter().println("<h3>Échec de la mise à jour. Veuillez vérifier l'ID de la chambre.</h3>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Erreur : " + e.getMessage() + "</h3>");
        }
    }
}