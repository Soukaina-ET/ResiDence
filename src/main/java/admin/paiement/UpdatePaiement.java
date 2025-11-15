package admin.paiement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/UpdatePaiement")
public class UpdatePaiement extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idPaiement = Integer.parseInt(request.getParameter("id"));
        int residentId = Integer.parseInt(request.getParameter("resident_id"));
        int chambreId = request.getParameter("chambre_id") != null && !request.getParameter("chambre_id").isEmpty() ?
                Integer.parseInt(request.getParameter("chambre_id")) : 0;
        double montantDue = Double.parseDouble(request.getParameter("montant_due"));
        double montantPaye = Double.parseDouble(request.getParameter("montant_paye"));
        String modePaiement = request.getParameter("mode_paiement");
        String statut = request.getParameter("statut");
        String commentaire = request.getParameter("commentaire");

        String url = "jdbc:mysql://localhost/residence";
        String driver = "com.mysql.cj.jdbc.Driver";

        try {
            Class.forName(driver);
            Connection con = DriverManager.getConnection(url, "root", "Soukaina2003");

            String sql = "UPDATE paiements SET resident_id = ?, chambre_id = ?, montant_due = ?, montant_paye = ?, " +
                    "mode_paiement = ?, statut = ?, commentaire = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, residentId);
            if (chambreId != 0) {
                ps.setInt(2, chambreId);
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setDouble(3, montantDue);
            ps.setDouble(4, montantPaye);
            ps.setString(5, modePaiement);
            ps.setString(6, statut);
            ps.setString(7, commentaire);
            ps.setInt(8, idPaiement);

            int result = ps.executeUpdate();

            if (result > 0) {
                response.sendRedirect("paiement.jsp");
            } else {
                response.getWriter().println("Erreur lors de la mise à jour du paiement.");
            }
            ps.close();
            con.close();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("Erreur de connexion à la base de données : " + e.getMessage());
        }
    }
}
