package admin.residents;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 * Servlet implementation class SuppressionServlet
 */
@WebServlet("/DeleteServlet")
public class DeleteServlet extends HttpServlet {
	private static final String DB_URL = "jdbc:mysql://localhost/residence";
	private static final String DB_USER = "root";
	private static final String DB_PASSWORD = "Soukaina2003";
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Récupérer l'ID du résident à supprimer
		String id = request.getParameter("id");

		// Vérifier si l'ID est valide
		if (id == null || id.isEmpty()) {
			response.getWriter().println("ID non fourni.");
			return;
		}

		// Connexion à la base de données
		String url = "jdbc:mysql://localhost/residence";
		String user = "root";
		String password = "Soukaina2003";
		String query = "DELETE FROM resident WHERE id = ?";

		try (Connection con = DriverManager.getConnection(url, user, password);
			 PreparedStatement ps = con.prepareStatement(query)) {

			// Remplir le paramètre de la requête
			ps.setString(1, id);

			// Exécuter la requête
			int rowsAffected = ps.executeUpdate();

			if (rowsAffected > 0) {
				response.sendRedirect("residents.jsp"); // Redirection après suppression réussie
			} else {
				response.getWriter().println("Aucun résident trouvé avec cet ID.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().println("Erreur : " + e.getMessage());
		}
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}


