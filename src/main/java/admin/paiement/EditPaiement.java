package admin.paiement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/EditPaiement")
public class EditPaiement extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idPaiement = Integer.parseInt(request.getParameter("id"));

        String url = "jdbc:mysql://localhost/residence";
        String driver = "com.mysql.cj.jdbc.Driver";

        try {
            Class.forName(driver);
            Connection con = DriverManager.getConnection(url, "root", "Soukaina2003");

            String sql = "SELECT * FROM paiements WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idPaiement);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("id", rs.getInt("id"));
                request.setAttribute("resident_id", rs.getInt("resident_id"));
                request.setAttribute("chambre_id", rs.getInt("chambre_id"));
                request.setAttribute("montant_due", rs.getDouble("montant_due"));
                request.setAttribute("montant_paye", rs.getDouble("montant_paye"));
                request.setAttribute("mode_paiement", rs.getString("mode_paiement"));
                request.setAttribute("commentaire", rs.getString("commentaire"));

                request.getRequestDispatcher("editPaiementForm.jsp").forward(request, response);
            }
            ps.close();
            con.close();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("Erreur de connexion à la base de données : " + e.getMessage());
        }
    }
}
