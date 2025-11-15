package admin.chambres;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Servlet implementation class SuppressionServlet
 */
@WebServlet("/SuppressionServlet")
public class SuppressionServlet extends HttpServlet {
	  protected void doGet(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {
	        // Paramètres de connexion à la base de données
	        String dbUrl = "jdbc:mysql://localhost/residence";
	        String dbUser = "root";
	        String dbPassword = "Soukaina2003";
	        String dbDriver = "com.mysql.cj.jdbc.Driver";

	        // Récupérer le paramètre CNE
	        String fid = request.getParameter("id");

	        // Vérification de la valeur de CNE
	        if (fid == null || fid.trim().isEmpty()) {
	            response.sendRedirect("Chambre.jsp?error=ID is missing");
	            return;
	        }

	        try {
	            // Charger le driver JDBC
	            Class.forName(dbDriver);

	            // Utiliser un try-with-resources pour gérer les connexions
	            try (Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
	                // Préparer la requête SQL avec un PreparedStatement
	                String sql = "DELETE FROM chambre WHERE id = ?";
	                try (PreparedStatement pstmt = con.prepareStatement(sql)) {
	                    pstmt.setString(1, fid);

	                    // Exécuter la requête
	                    int rowsAffected = pstmt.executeUpdate();

	                    // Vérifier si une suppression a eu lieu
	                    if (rowsAffected > 0) {
	                        response.sendRedirect("Chambre.jsp?message=Chambre supprimé avec succès");
	                    } else {
	                        response.sendRedirect("Chambre.jsp?error=Chambre introuvable");
	                    }
	                }
	            }
	        } catch (SQLException | ClassNotFoundException e) {
	            // Gérer les exceptions
	            e.printStackTrace();
	            response.sendRedirect("Chambre.jsp?error=Erreur : " + e.getMessage());
	        }
	    }
}
