package resident.classes;

import admin.classes.EmailUtil;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import resident.DatabaseConnection.DatabaseConnection;
import resident.paiement.PaymentStatusUpdater;
import java.sql.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PaymentReminderJob implements Job {
    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        try {
            // Mettre à jour les statuts des paiements
            PaymentStatusUpdater.updatePaymentStatus();

            // Récupérer les résidents avec des paiements en retard
            List<String> emails = getResidentsWithPendingPayments();

            // Envoyer un e-mail à chaque résident
            for (String email : emails) {
                EmailUtil.sendEmail(email, "Rappel de paiement", "Bonjour,\n\nVotre paiement est en retard. Veuillez régulariser votre situation dès que possible.\n\nCordialement,\nL'équipe de gestion de la résidence.");
            }
        } catch (Exception e) {
            throw new JobExecutionException(e);
        }
    }

    // Méthode pour récupérer les e-mails des résidents avec des paiements en retard
    private List<String> getResidentsWithPendingPayments() throws SQLException {
        List<String> emails = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT r.email FROM residents r " +
                    "JOIN paiements p ON r.id = p.resident_id " +
                    "WHERE p.statut = 'En retard'";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    emails.add(rs.getString("email"));
                }
            }
        }
        return emails;
    }
}
