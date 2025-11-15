package admin.paiement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.pdfbox.pdmodel.*;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;

import java.awt.Color;
import java.io.IOException;
import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;

@WebServlet("/GenererRecu")
public class GenererRecu extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idPaiementParam = request.getParameter("id");
        if (idPaiementParam == null || idPaiementParam.isEmpty()) {
            response.setContentType("text/plain");
            response.getWriter().write("Erreur : ID du paiement non fourni ou invalide.");
            return;
        }

        int idPaiement;
        try {
            idPaiement = Integer.parseInt(idPaiementParam);
        } catch (NumberFormatException e) {
            response.getWriter().write("Erreur : ID du paiement doit être un entier valide.");
            return;
        }

        String url = "jdbc:mysql://localhost/residence";
        String user = "root";
        String password = "Soukaina2003";
        String driver = "com.mysql.cj.jdbc.Driver";

        try {
            Class.forName(driver);
            Connection con = DriverManager.getConnection(url, user, password);
            String sql = "SELECT p.*, r.nom, r.prenom, c.id AS chambre_id " +
                    "FROM paiements p " +
                    "LEFT JOIN resident r ON p.resident_id = r.id " +
                    "LEFT JOIN chambre c ON r.chambre_id = c.id " +
                    "WHERE p.id = ?;";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idPaiement);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                PDDocument document = new PDDocument();
                PDPage page = new PDPage(PDRectangle.A4);
                document.addPage(page);

                PDPageContentStream contentStream = new PDPageContentStream(document, page);

                // Couleurs - dégradé de bleu moderne
                Color headerBlue = new Color(52, 152, 219);      // Bleu vif
                Color accentBlue = new Color(41, 128, 185);      // Bleu moyen
                Color darkBlue = new Color(31, 97, 141);         // Bleu foncé
                Color textDark = new Color(44, 62, 80);          // Gris foncé
                Color textMedium = new Color(127, 140, 141);     // Gris moyen
                Color bgLight = new Color(236, 240, 241);        // Gris très clair
                Color successGreen = new Color(39, 174, 96);     // Vert

                // === HEADER AVEC DÉGRADÉ BLEU ===
                // Fond bleu principal
                contentStream.setNonStrokingColor(headerBlue);
                contentStream.addRect(0, 730, 595, 112);
                contentStream.fill();

                // Bande bleu foncé en haut
                contentStream.setNonStrokingColor(darkBlue);
                contentStream.addRect(0, 820, 595, 22);
                contentStream.fill();

                // Logo blanc sur fond bleu
                try {
                    ClassLoader classLoader = getClass().getClassLoader();
                    PDImageXObject logo = PDImageXObject.createFromFile(
                            classLoader.getResource("images/Residetblancicone.png").getPath(), document
                    );
                    contentStream.drawImage(logo, 45, 755, 75, 75);
                } catch (Exception e) {
                    System.out.println("Logo non trouvé: " + e.getMessage());
                }

                // Titre "REÇU DE PAIEMENT" en blanc
                contentStream.setNonStrokingColor(Color.WHITE);
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 26);
                contentStream.beginText();
                contentStream.newLineAtOffset(145, 790);
                contentStream.showText("REÇU DE PAIEMENT");
                contentStream.endText();

                // Sous-titre
                contentStream.setFont(PDType1Font.HELVETICA, 11);
                contentStream.beginText();
                contentStream.newLineAtOffset(145, 770);
                contentStream.showText("Résidence Universitaire");
                contentStream.endText();

                // Boîte numéro de reçu (coin supérieur droit)
                contentStream.setNonStrokingColor(Color.WHITE);
                contentStream.addRect(440, 785, 110, 40);
                contentStream.fill();

                contentStream.setStrokingColor(new Color(255, 255, 255, 50));
                contentStream.setLineWidth(1);
                contentStream.addRect(440, 785, 110, 40);
                contentStream.stroke();

                contentStream.setNonStrokingColor(darkBlue);
                contentStream.setFont(PDType1Font.HELVETICA, 9);
                contentStream.beginText();
                contentStream.newLineAtOffset(465, 813);
                contentStream.showText("N° " + String.format("%06d", rs.getInt("id")));
                contentStream.endText();

                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                contentStream.setFont(PDType1Font.HELVETICA, 8);
                contentStream.beginText();
                contentStream.newLineAtOffset(457, 795);
                contentStream.showText(dateFormat.format(rs.getDate("date_paiement")));
                contentStream.endText();

                // === SECTION INFORMATIONS DU RÉSIDENT ===
                int yPos = 690;

                // Titre de section avec ligne bleue
                contentStream.setNonStrokingColor(textDark);
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 13);
                contentStream.beginText();
                contentStream.newLineAtOffset(55, yPos);
                contentStream.showText("Informations du Résident");
                contentStream.endText();

                contentStream.setStrokingColor(accentBlue);
                contentStream.setLineWidth(2.5f);
                contentStream.moveTo(55, yPos - 5);
                contentStream.lineTo(215, yPos - 5);
                contentStream.stroke();

                // Boîte informations résident
                yPos -= 25;
                contentStream.setNonStrokingColor(bgLight);
                contentStream.addRect(55, yPos - 55, 485, 65);
                contentStream.fill();

                contentStream.setStrokingColor(new Color(200, 204, 206));
                contentStream.setLineWidth(1);
                contentStream.addRect(55, yPos - 55, 485, 65);
                contentStream.stroke();

                // Contenu - Nom complet
                contentStream.setNonStrokingColor(textMedium);
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 9);
                contentStream.beginText();
                contentStream.newLineAtOffset(70, yPos - 15);
                contentStream.showText("Nom complet:");
                contentStream.endText();

                contentStream.setNonStrokingColor(textDark);
                contentStream.setFont(PDType1Font.HELVETICA, 11);
                contentStream.beginText();
                contentStream.newLineAtOffset(155, yPos - 16);
                contentStream.showText(rs.getString("nom") + " " + rs.getString("prenom"));
                contentStream.endText();

                // Contenu - Chambre
                contentStream.setNonStrokingColor(textMedium);
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 9);
                contentStream.beginText();
                contentStream.newLineAtOffset(70, yPos - 40);
                contentStream.showText("Chambre:");
                contentStream.endText();

                contentStream.setNonStrokingColor(textDark);
                contentStream.setFont(PDType1Font.HELVETICA, 11);
                contentStream.beginText();
                contentStream.newLineAtOffset(155, yPos - 41);
                contentStream.showText("Chambre N° " + rs.getString("chambre_id"));
                contentStream.endText();

                // === SECTION DÉTAILS DU PAIEMENT ===
                yPos -= 100;

                contentStream.setNonStrokingColor(textDark);
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 13);
                contentStream.beginText();
                contentStream.newLineAtOffset(55, yPos);
                contentStream.showText("Détails du Paiement");
                contentStream.endText();

                contentStream.setStrokingColor(accentBlue);
                contentStream.setLineWidth(2.5f);
                contentStream.moveTo(55, yPos - 5);
                contentStream.lineTo(195, yPos - 5);
                contentStream.stroke();

                // Tableau des détails
                yPos -= 30;
                int rowHeight = 38;

                // Ligne 1 - Montant dû
                contentStream.setNonStrokingColor(bgLight);
                contentStream.addRect(55, yPos - rowHeight, 485, rowHeight);
                contentStream.fill();

                contentStream.setStrokingColor(new Color(200, 204, 206));
                contentStream.setLineWidth(0.5f);
                contentStream.addRect(55, yPos - rowHeight, 485, rowHeight);
                contentStream.stroke();

                contentStream.setNonStrokingColor(textMedium);
                contentStream.setFont(PDType1Font.HELVETICA, 9);
                contentStream.beginText();
                contentStream.newLineAtOffset(70, yPos - 15);
                contentStream.showText("Montant dû");
                contentStream.endText();

                contentStream.setNonStrokingColor(textDark);
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 13);
                contentStream.beginText();
                contentStream.newLineAtOffset(400, yPos - 18);
                contentStream.showText(String.format("%.2f MAD", rs.getDouble("montant_due")));
                contentStream.endText();

                yPos -= rowHeight;

                // Ligne 2 - Montant payé
                contentStream.setStrokingColor(new Color(200, 204, 206));
                contentStream.setLineWidth(0.5f);
                contentStream.addRect(55, yPos - rowHeight, 485, rowHeight);
                contentStream.stroke();

                contentStream.setNonStrokingColor(textMedium);
                contentStream.setFont(PDType1Font.HELVETICA, 9);
                contentStream.beginText();
                contentStream.newLineAtOffset(70, yPos - 15);
                contentStream.showText("Montant payé");
                contentStream.endText();

                contentStream.setNonStrokingColor(textDark);
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 13);
                contentStream.beginText();
                contentStream.newLineAtOffset(400, yPos - 18);
                contentStream.showText(String.format("%.2f MAD", rs.getDouble("montant_paye")));
                contentStream.endText();

                yPos -= rowHeight;

                // Ligne 3 - Statut avec badge
                contentStream.setNonStrokingColor(bgLight);
                contentStream.addRect(55, yPos - rowHeight, 485, rowHeight);
                contentStream.fill();

                contentStream.setStrokingColor(new Color(200, 204, 206));
                contentStream.setLineWidth(0.5f);
                contentStream.addRect(55, yPos - rowHeight, 485, rowHeight);
                contentStream.stroke();

                contentStream.setNonStrokingColor(textMedium);
                contentStream.setFont(PDType1Font.HELVETICA, 9);
                contentStream.beginText();
                contentStream.newLineAtOffset(70, yPos - 15);
                contentStream.showText("Statut");
                contentStream.endText();

                // Badge de statut
                String statut = rs.getString("statut");
                Color badgeColor = successGreen;
                if (!"Payé".equalsIgnoreCase(statut) && !"Complet".equalsIgnoreCase(statut)) {
                    badgeColor = new Color(231, 76, 60); // Rouge
                }

                contentStream.setNonStrokingColor(badgeColor);
                contentStream.addRect(395, yPos - 25, 130, 24);
                contentStream.fill();

                contentStream.setNonStrokingColor(Color.WHITE);
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 11);
                contentStream.beginText();
                contentStream.newLineAtOffset(445, yPos - 16);
                contentStream.showText(statut.toUpperCase());
                contentStream.endText();

                // === SIGNATURE ===
                yPos = 180;
                try {
                    ClassLoader classLoader = getClass().getClassLoader();
                    PDImageXObject signature = PDImageXObject.createFromFile(
                            classLoader.getResource("images/signature.png").getPath(), document
                    );
                    contentStream.drawImage(signature, 370, yPos - 10, 150, 50);
                } catch (Exception e) {
                    System.out.println("Signature non trouvée: " + e.getMessage());
                }

                contentStream.setNonStrokingColor(textDark);
                contentStream.setFont(PDType1Font.HELVETICA, 9);
                contentStream.beginText();
                contentStream.newLineAtOffset(385, yPos - 30);
                contentStream.showText("Direction de la Résidence");
                contentStream.endText();

                // === FOOTER BLEU ===
                contentStream.setNonStrokingColor(headerBlue);
                contentStream.addRect(0, 0, 595, 95);
                contentStream.fill();

                contentStream.setNonStrokingColor(Color.WHITE);
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 10);
                contentStream.beginText();
                contentStream.newLineAtOffset(55, 60);
                contentStream.showText("Merci de conserver ce reçu comme preuve de paiement");
                contentStream.endText();

                contentStream.setFont(PDType1Font.HELVETICA, 8);
                contentStream.beginText();
                contentStream.newLineAtOffset(55, 45);
                contentStream.showText("Pour toute question, contactez l'administration de la résidence");
                contentStream.endText();

                SimpleDateFormat fullDateFormat = new SimpleDateFormat("EEE MMM dd HH:mm:ss 'GMT'Z yyyy");
                contentStream.setFont(PDType1Font.HELVETICA_OBLIQUE, 7);
                contentStream.beginText();
                contentStream.newLineAtOffset(55, 20);
                contentStream.showText("Document généré automatiquement - " + fullDateFormat.format(new java.util.Date()));
                contentStream.endText();

                contentStream.close();

                // Envoyer le PDF
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "inline; filename=recu_" + idPaiement + ".pdf");
                document.save(response.getOutputStream());
                document.close();
            } else {
                response.setContentType("text/plain");
                response.getWriter().println("Aucun paiement trouvé pour l'ID: " + idPaiement);
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors de la génération du reçu : " + e.getMessage());
        }
    }
}