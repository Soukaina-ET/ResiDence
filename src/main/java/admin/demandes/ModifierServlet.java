package admin.demandes;

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

/**
 * Servlet implementation class ModificationServlet
 */
@MultipartConfig
@WebServlet("/ModifierServlet")
public class ModifierServlet extends HttpServlet {
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
        String fprenom = request.getParameter("prenom");
        String femail = request.getParameter("email");
        String ftelephone = request.getParameter("telephone");
        String fcne = request.getParameter("cne");


        // Gestion de l'image
        // Récupérer l'image téléchargée
        Part filePart = request.getPart("carte_etudiante");
        InputStream inputStream = filePart.getInputStream(); // Récupérer le flux d'entrée de l'image
        Date fdate = Date.valueOf(request.getParameter("date_demande"));
        // Connexion à la base de données
        String url = "jdbc:mysql://localhost/residence";
        String driver = "com.mysql.cj.jdbc.Driver";
        try (Connection con = DriverManager.getConnection(url, "root", "Soukaina2003");
             PreparedStatement pstmt = con.prepareStatement("UPDATE resident SET nom = ?, prenom = ?, email = ?, telephone = ?, cne = ?, carte_etudiante = COALESCE(?, carte_etudiante), date_demande = ? WHERE id = ?");) {
        	System.out.println("Requête SQL exécutée : UPDATE chambre SET ... WHERE id = " + fid);
            pstmt.setString(1, fnom);
            pstmt.setString(2, fprenom);
            pstmt.setString(3, femail);
            pstmt.setString(4, ftelephone);
            pstmt.setString(5, fcne);
            // Passer le flux d'image à la requête préparée pour le champ BLOB
            if (inputStream != null) {
                pstmt.setBinaryStream(6, inputStream); // Insérer l'image en tant que BLOB
            } else {
                pstmt.setNull(6, Types.BLOB); // Si aucune image n'est téléchargée, mettre NULL
            }
            pstmt.setDate(7,fdate);
            pstmt.setString(8, fid);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("resident.jsp"); // Redirection en cas de succès
            } else {
                response.getWriter().println("<h3>Échec de la mise à jour. Veuillez vérifier l'ID de la chambre.</h3>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Erreur : " + e.getMessage() + "</h3>");

        }
        if (fid == null || fid.isEmpty()) {
            response.getWriter().println("<h3>Erreur : L'ID est manquant.</h3>");
            return;
        }
        if (fnom == null || fnom.isEmpty() || fprenom == null || fprenom.isEmpty()) {
            response.getWriter().println("<h3>Erreur : Le nom et le prénom sont obligatoires.</h3>");
            return;
        }

    }
}