package admin.demandes;

import admin.classes.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Servlet implementation class SuppressionServlet
 */
@WebServlet("/SupprimerServlet")
public class SupprimerServlet extends HttpServlet {
	private static final String DB_URL = "jdbc:mysql://localhost/residence";
	private static final String DB_USER = "root";
	private static final String DB_PASSWORD = "Soukaina2003";
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String id = request.getParameter("id");

		try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
			// Récupérer l'email
			String selectQuery = "SELECT email FROM demandes_inscription WHERE id = ?";
			PreparedStatement selectStmt = con.prepareStatement(selectQuery);
			selectStmt.setString(1, id);
			ResultSet rs = selectStmt.executeQuery();

			if (rs.next()) {
				String email = rs.getString("email");

				// Supprimer la demande
				String deleteQuery = "DELETE FROM demandes_inscription WHERE id = ?";
				PreparedStatement deleteStmt = con.prepareStatement(deleteQuery);
				deleteStmt.setString(1, id);
				deleteStmt.executeUpdate();

				// Envoyer un email de rejet
				EmailUtil.sendEmail(email, "Demande rejetée", "Bonjour,\n\nVotre demande d'inscription a été rejetée. Si vous pensez que cela est une erreur, veuillez nous contacter.\n\nCordialement,\nL'équipe de la résidence.");
               // Valider la transaction
				con.commit();

				// Ajouter un message à la requête et rediriger
				request.setAttribute("message", "Rejet validée avec succès !");
				request.getRequestDispatcher("/demandes.jsp").forward(request, response);
			} else {
				request.setAttribute("error", "Aucune demande trouvée avec cet ID.");
				request.getRequestDispatcher("/demandes.jsp").forward(request, response);
			}
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "Erreur : " + e.getMessage());
			request.getRequestDispatcher("/demandes.jsp").forward(request, response);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}


