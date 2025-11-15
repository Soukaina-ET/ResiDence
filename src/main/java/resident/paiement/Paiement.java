package resident.paiement;

import java.math.BigDecimal;
import java.sql.Timestamp;

// Classe Paiement pour représenter un paiement
class Paiement {
    private int id;
    private java.math.BigDecimal montantDue;
    private java.math.BigDecimal montantPaye;
    private Timestamp datePaiement;
    private String modePaiement;
    private String statut;
    private String commentaire;
    private String recuUrl;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public BigDecimal getMontantDue() {
        return montantDue;
    }

    public void setMontantDue(BigDecimal montantDue) {
        this.montantDue = montantDue;
    }

    public BigDecimal getMontantPaye() {
        return montantPaye;
    }

    public void setMontantPaye(BigDecimal montantPaye) {
        this.montantPaye = montantPaye;
    }

    public Timestamp getDatePaiement() {
        return datePaiement;
    }

    public void setDatePaiement(Timestamp datePaiement) {
        this.datePaiement = datePaiement;
    }

    public String getModePaiement() {
        return modePaiement;
    }

    public void setModePaiement(String modePaiement) {
        this.modePaiement = modePaiement;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public String getCommentaire() {
        return commentaire;
    }

    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }

    public String getRecuUrl() {
        return recuUrl;
    }

    public void setRecuUrl(String recuUrl) {
        this.recuUrl = recuUrl;
    }

    // Getters et Setters
    // (Ajoutez les getters et setters pour chaque attribut)
}
