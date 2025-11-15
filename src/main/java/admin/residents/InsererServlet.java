package admin.residents;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;


/**
 * Servlet implementation class InsertionServlet
 */
@MultipartConfig
@WebServlet("/InsererServlet")
public class InsererServlet extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Récupérer les paramètres du formulaire
		String nom = request.getParameter("nom");
		String prenom = request.getParameter("prenom");
		String email = request.getParameter("email");
		String telephone = request.getParameter("telephone");
		String cne = request.getParameter("cne");
		// Générer la date actuelle
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String dateDemande = formatter.format(new Date());
		String chambreId = request.getParameter("chambre_id");

		// Récupérer l'image de la carte d'étudiant
		Part carteEtudiantePart = request.getPart("carte_etudiante");
		InputStream carteEtudianteInputStream = carteEtudiantePart.getInputStream();

		// Connexion à la base de données
		String url = "jdbc:mysql://localhost/residence";
		String driver = "com.mysql.cj.jdbc.Driver";
		try {
			Class.forName(driver);
			Connection con = DriverManager.getConnection(url, "root", "Soukaina2003");

			// Insérer le résident dans la base de données
			String sql = "INSERT INTO resident (nom, prenom, email, telephone, cne, carte_etudiante, date_demande, chambre_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement ps = con.prepareStatement(sql);

			// Remplir les paramètres de la requête préparée
			ps.setString(1, nom);
			ps.setString(2, prenom);
			ps.setString(3, email);
			ps.setString(4, telephone);
			ps.setString(5, cne);
			ps.setBlob(6, carteEtudianteInputStream); // Carte d'étudiant en tant que BLOB
			ps.setString(7, dateDemande); // Conversion de la date au format SQL
			ps.setString(8, chambreId);

			// Exécuter la requête
			int result = ps.executeUpdate();

			if (result > 0) {
				// Mettre à jour le statut de la chambre
				if (chambreId != null && !chambreId.isEmpty()) {
					String updateChambreSql = "UPDATE chambre SET statut = 'occupée' WHERE id = ?";
					PreparedStatement updatePs = con.prepareStatement(updateChambreSql);
					updatePs.setString(1, chambreId);
					updatePs.executeUpdate();
					updatePs.close();
				}
				response.sendRedirect("residents.jsp"); // Rediriger vers la page des résidents
			} else {
				response.getWriter().println("Erreur lors de l'insertion des données.");
			}

			// Fermer la connexion et la déclaration
			ps.close();
			con.close();
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			response.getWriter().println("Erreur de connexion à la base de données : " + e.getMessage());
		}
	}
}