package admin.admins;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;




@WebServlet("/EditAdmin")
public class EditAdmin extends HttpServlet {
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
        String fnom = request.getParameter("nom");
        String ftelephone = request.getParameter("telephone");
        String femail = request.getParameter("email");
        String fcnie= request.getParameter("cnie");
        // Connexion à la base de données
        String url = "jdbc:mysql://localhost/residence";
        String driver = "com.mysql.cj.jdbc.Driver";
        try (Connection con = DriverManager.getConnection(url, "root", "Soukaina2003");
             PreparedStatement pstmt = con.prepareStatement("UPDATE admin SET nom = ?, telephone = ?, email = ?, cnie = ? WHERE id = ?");) {
            System.out.println("Requête SQL exécutée : UPDATE chambre SET ... WHERE id = " + fid);
            pstmt.setString(1, fnom);
            pstmt.setString(2, ftelephone);
            pstmt.setString(3, femail);
            pstmt.setString(4, fcnie);;
            pstmt.setString(5, fid);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("admins.jsp"); // Redirection en cas de succès
            } else {
                response.getWriter().println("<h3>Échec de la mise à jour. Veuillez vérifier l'ID de la chambre.</h3>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Erreur : " + e.getMessage() + "</h3>");
        }
    }
}