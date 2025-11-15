package admin.paiement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.*;

  @WebServlet("/InsererPaiement")
public class InsererPaiement extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int residentId = Integer.parseInt(request.getParameter("resident_id"));
        int chambreId = request.getParameter("chambre_id") != null && !request.getParameter("chambre_id").isEmpty() ?
                Integer.parseInt(request.getParameter("chambre_id")) : null;
        double montantDue = Double.parseDouble(request.getParameter("montant_due"));
        double montantPaye = Double.parseDouble(request.getParameter("montant_paye"));
        String modePaiement = request.getParameter("mode_paiement");
        String commentaire = request.getParameter("commentaire");

        // Statut par défaut à 'En attente'
        String statut = "En attente";

        String url = "jdbc:mysql://localhost/residence";
        String driver = "com.mysql.cj.jdbc.Driver";

        try {
            Class.forName(driver);
            Connection con = DriverManager.getConnection(url, "root", "Soukaina2003");

            String sql = "INSERT INTO paiements (resident_id, chambre_id, montant_due, montant_paye, mode_paiement, statut, commentaire) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, residentId);
            if (chambreId != 0) ps.setInt(2, chambreId); else ps.setNull(2, java.sql.Types.INTEGER); // Si chambre_id est vide, on le laisse null
            ps.setDouble(3, montantDue);
            ps.setDouble(4, montantPaye);
            ps.setString(5, modePaiement);
            ps.setString(6, statut);
            ps.setString(7, commentaire);

            int result = ps.executeUpdate();

            if (result > 0) {
                response.sendRedirect("paiement.jsp");
            } else {
                response.getWriter().println("Erreur lors de l'insertion du paiement.");
            }
            ps.close();
            con.close();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("Erreur de connexion à la base de données : " + e.getMessage());
        }
    }
    @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

}
