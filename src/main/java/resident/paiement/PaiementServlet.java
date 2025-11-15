package resident.paiement;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import resident.DatabaseConnection.DatabaseConnection;

@WebServlet("/PaiementServlet")
@MultipartConfig
public class PaiementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer l'ID du résident depuis la session
        HttpSession session = request.getSession();
        Integer residentId = (Integer) session.getAttribute("id");

        if (residentId == null) {
            response.sendRedirect("FormulaireConnexion.jsp"); // Rediriger vers la page de connexion si l'utilisateur n'est pas connecté
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Récupérer les paiements du résident
            String sql = "SELECT * FROM paiements WHERE resident_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, residentId);
                ResultSet rs = stmt.executeQuery();

                List<Paiement> paiements = new ArrayList<>();
                while (rs.next()) {
                    Paiement paiement = new Paiement();
                    paiement.setId(rs.getInt("id"));
                    paiement.setMontantDue(rs.getBigDecimal("montant_due"));
                    paiement.setMontantPaye(rs.getBigDecimal("montant_paye"));
                    paiement.setDatePaiement(rs.getTimestamp("date_paiement"));
                    paiement.setModePaiement(rs.getString("mode_paiement"));
                    paiement.setStatut(rs.getString("statut"));
                    paiement.setCommentaire(rs.getString("commentaire"));
                    paiement.setRecuUrl(rs.getString("recu_url"));
                    paiements.add(paiement);
                }

                request.setAttribute("paiements", paiements);
                request.getRequestDispatcher("paiementResident.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur s'est produite lors de la récupération des paiements.");
            request.getRequestDispatcher("paiementResident.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer l'ID du résident depuis la session
        HttpSession session = request.getSession();
        Integer residentId = (Integer) session.getAttribute("id");

        if (residentId == null) {
            response.sendRedirect("FormulaireConnexion.jsp"); // Rediriger vers la page de connexion si l'utilisateur n'est pas connecté
            return;
        }

        // Récupérer les données du formulaire
        String montantDue = request.getParameter("montant_due");
        String montantPaye = request.getParameter("montant_paye");
        String modePaiement = request.getParameter("mode_paiement");
        String commentaire = request.getParameter("commentaire");

        // Validation des données
        if (montantPaye == null || montantPaye.isEmpty() || montantDue.isEmpty() || modePaiement == null || modePaiement.isEmpty()) {
            request.setAttribute("errorMessage", "Veuillez remplir tous les champs obligatoires.");
            request.getRequestDispatcher("residentJsp/paiementResident.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Insérer le nouveau paiement
            String sql = "INSERT INTO paiements (resident_id, montant_due, montant_paye, mode_paiement, commentaire, statut) VALUES (?, ?, ?, ?, ?, 'En attente')";
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, residentId);
                stmt.setBigDecimal(2, new java.math.BigDecimal(montantDue));
                stmt.setBigDecimal(3, new java.math.BigDecimal(montantPaye));
                stmt.setString(4, modePaiement);
                stmt.setString(5, commentaire);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    request.setAttribute("successMessage", "Paiement soumis avec succès. Attendez la confirmation de l'administration.");
                } else {
                    request.setAttribute("errorMessage", "Erreur lors de la soumission du paiement.");
                }
                response.sendRedirect("residentJsp/paiementResident.jsp"); // Rediriger vers la page des paiements
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur s'est produite lors de la soumission du paiement.");
            request.getRequestDispatcher("residentJsp/paiementResident.jsp").forward(request, response);
        }
    }
}

