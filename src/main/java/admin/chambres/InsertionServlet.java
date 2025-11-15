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
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Servlet implementation class InsertionServlet
 */
@MultipartConfig
@WebServlet("/InsertionServlet")
public class InsertionServlet extends HttpServlet {
        @Override
	    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method not supported for this request.");
	    }

	    @Override
	    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        response.setContentType("text/html;charset=UTF-8");

	        // Récupération des paramètres
	        String ftype_chambre = request.getParameter("type_chambre");
	        String fprix_location_jour = request.getParameter("prix_location_jour");
	        String fpersonne_max = request.getParameter("personne_max");
	        String fcaracteristiques = request.getParameter("caracteristiques");
	        String fstatut = request.getParameter("statut");

	        // Gestion du fichier image
	        Part filePart = request.getPart("image_path");
	        String fimage_path = null;

	        if (filePart != null && filePart.getSize() > 0) {
	            String fileName = filePart.getSubmittedFileName();
	            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
	            File uploadDir = new File(uploadPath);
	            if (!uploadDir.exists()) {
	                uploadDir.mkdir(); // Crée le dossier si inexistant
	            }
	            fimage_path = "images/" + fileName;
	            filePart.write(uploadPath + File.separator + fileName);
	        }

	        // Connexion à la base de données
	        String url = "jdbc:mysql://localhost/residence";
	        String driver = "com.mysql.cj.jdbc.Driver";
	        Connection con = null;
	        PreparedStatement pstmt = null;

	        try (PrintWriter out = response.getWriter()) {
	            Class.forName(driver);
	            con = DriverManager.getConnection(url, "root", "Soukaina2003");

	            // Requête SQL avec des placeholders
	            String sql = "INSERT INTO chambre (type_chambre, prix_location_jour, personne_max, caracteristiques, statut, image_path) " +
	                         "VALUES (?, ?, ?, ?, ?, ?)";
	            pstmt = con.prepareStatement(sql);

	            // Attribution des valeurs aux placeholders
	            pstmt.setString(1, ftype_chambre);
	            pstmt.setString(2, fprix_location_jour);
	            pstmt.setString(3, fpersonne_max);
	            pstmt.setString(4, fcaracteristiques);
	            pstmt.setString(5, fstatut);
	            pstmt.setString(6, fimage_path);

	            int rowsAffected = pstmt.executeUpdate();

	            if (rowsAffected > 0) {
	                response.sendRedirect("Chambre.jsp"); // Redirection en cas de succès
	            } else {
	                out.println("Insertion échouée.");
	            }
	        } catch (SQLException | ClassNotFoundException e) {
	            e.printStackTrace();
	            response.getWriter().println("Erreur : " + e.getMessage());
	        } finally {
	            try {
	                if (pstmt != null) pstmt.close();
	                if (con != null) con.close();
	            } catch (SQLException e) {
	                e.printStackTrace();
	            }
	        }
	    }
}
