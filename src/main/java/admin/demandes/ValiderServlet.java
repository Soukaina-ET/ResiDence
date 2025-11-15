package admin.demandes;

import admin.classes.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

/**
 * Servlet implementation class InsertionServlet
 */
@MultipartConfig
@WebServlet("/ValiderServlet")
public class ValiderServlet extends HttpServlet {
	private static final String DB_URL = "jdbc:mysql://localhost/residence";
	private static final String DB_USER = "root";
	private static final String DB_PASSWORD = "Soukaina2003";

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String id = request.getParameter("id");

		try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
			con.setAutoCommit(false);

			// Récupérer les données de `demandes_inscription`
			String selectQuery = "SELECT * FROM demandes_inscription WHERE id = ?";
			PreparedStatement selectStmt = con.prepareStatement(selectQuery);
			selectStmt.setString(1, id);
			ResultSet rs = selectStmt.executeQuery();

			if (rs.next()) {
				// Extraire les informations
				String nom = rs.getString("nom");
				String prenom = rs.getString("prenom");
				String telephone = rs.getString("telephone");
				String email = rs.getString("email");
				String cne = rs.getString("CNE");
				Blob carteEtudiante = rs.getBlob("carte_etudiante");
				Timestamp dateDemande = rs.getTimestamp("date_demande");
				String userPassword = rs.getString("password");

				// Générer un salt
				String salt = generateSalt();

				// Insérer dans `resident`
				String insertQuery = "INSERT INTO resident (nom, prenom, telephone, email, CNE, carte_etudiante, date_demande, password, salt) " +
						"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
				PreparedStatement insertStmt = con.prepareStatement(insertQuery);
				insertStmt.setString(1, nom);
				insertStmt.setString(2, prenom);
				insertStmt.setString(3, telephone);
				insertStmt.setString(4, email);
				insertStmt.setString(5, cne);
				insertStmt.setBlob(6, carteEtudiante);
				insertStmt.setTimestamp(7, dateDemande);
				insertStmt.setString(8, userPassword);
				insertStmt.setString(9, salt);
				insertStmt.executeUpdate();

				// Supprimer de `demandes_inscription`
				String deleteQuery = "DELETE FROM demandes_inscription WHERE id = ?";
				PreparedStatement deleteStmt = con.prepareStatement(deleteQuery);
				deleteStmt.setString(1, id);
				deleteStmt.executeUpdate();

				// Envoyer un email de confirmation
				EmailUtil.sendEmail(email, "Inscription validée",
						"Bonjour " + prenom + ",\n\nVotre inscription a été validée avec succès. Vous pouvez vous connecter avec le mot de passe que vous avez fourni.\n\nCordialement,\nL'équipe de la résidence.");

				// Valider la transaction
				con.commit();

// Ajouter un message à la requête et rediriger
				request.setAttribute("message", "Inscription validée avec succès !");
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

	private String generateSalt() {
		return Long.toHexString(Double.doubleToLongBits(Math.random()));
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}
