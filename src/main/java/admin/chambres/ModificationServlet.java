package admin.chambres;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Servlet implementation class ModificationServlet
 */
@MultipartConfig
@WebServlet("/ModificationServlet")
public class ModificationServlet extends HttpServlet {
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
        String ftype_chambre = request.getParameter("type_chambre");
        String fprix_location_jour = request.getParameter("prix_location_jour");
        String fpersonne_max = request.getParameter("personne_max");
        String fcaracteristiques = request.getParameter("caracteristiques");
        String fstatut = request.getParameter("statut");

        // Gestion de l'image
        Part filePart = request.getPart("image_path");
        String fimage_path = null;

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            fimage_path = "images/" + fileName;
            filePart.write(uploadPath + File.separator + fileName);
        }

        // Connexion à la base de données
        String url = "jdbc:mysql://localhost/residence";
        String driver = "com.mysql.cj.jdbc.Driver";
        try (Connection con = DriverManager.getConnection(url, "root", "Soukaina2003");
             PreparedStatement pstmt = con.prepareStatement("UPDATE chambre SET type_chambre = ?, prix_location_jour = ?, personne_max = ?, caracteristiques = ?, statut = ?, image_path = COALESCE(?, image_path) WHERE id = ?");) {
        	System.out.println("Requête SQL exécutée : UPDATE chambre SET ... WHERE id = " + fid);
            pstmt.setString(1, ftype_chambre);
            pstmt.setString(2, fprix_location_jour);
            pstmt.setString(3, fpersonne_max);
            pstmt.setString(4, fcaracteristiques);
            pstmt.setString(5, fstatut);
            pstmt.setString(6, fimage_path);
            pstmt.setString(7, fid);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("Chambre.jsp"); // Redirection en cas de succès
            } else {
                response.getWriter().println("<h3>Échec de la mise à jour. Veuillez vérifier l'ID de la chambre.</h3>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Erreur : " + e.getMessage() + "</h3>");
        }
    }
}