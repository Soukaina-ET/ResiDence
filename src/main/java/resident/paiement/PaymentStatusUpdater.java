package resident.paiement;

import java.sql.*;
import java.time.LocalDate;
import java.time.YearMonth;
import resident.DatabaseConnection.DatabaseConnection;

public class PaymentStatusUpdater {

    public static void updatePaymentStatus() throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Récupérer tous les paiements non payés
            String sql = "SELECT id, resident_id, montant_due, montant_paye, date_paiement, date_limite FROM paiements WHERE statut != 'Payé'";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    int paymentId = rs.getInt("id");
                    LocalDate paymentDate = rs.getTimestamp("date_paiement").toLocalDateTime().toLocalDate();
                    double montantDue = rs.getDouble("montant_due");
                    double montantPaye = rs.getDouble("montant_paye");
                    LocalDate dateLimit = rs.getDate("date_limite").toLocalDate();

                    // Déterminer le statut en fonction de la date actuelle
                    String newStatus = determinePaymentStatus(paymentDate, montantDue, montantPaye, dateLimit);

                    // Mettre à jour le statut dans la base de données
                    updateStatusInDatabase(conn, paymentId, newStatus);
                }
            }
        }
    }

    // Méthode pour déterminer le statut du paiement
    private static String determinePaymentStatus(LocalDate paymentDate, double montantDue, double montantPaye, LocalDate dateLimite) {
        LocalDate today = LocalDate.now();

        if (montantPaye >= montantDue) {
            return "Payé"; // Le paiement est complet
        } else if (today.isBefore(dateLimite)) {
            return "En attente"; // Le paiement n'est pas encore en retard
        } else {
            return "En retard"; // Le paiement est en retard
        }
    }

    // Méthode pour mettre à jour le statut dans la base de données
    private static void updateStatusInDatabase(Connection conn, int paymentId, String newStatus) throws SQLException {
        String sql = "UPDATE paiements SET statut = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, paymentId);
            stmt.executeUpdate();
        }
    }
}
