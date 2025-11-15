<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <!-- Charger Bootstrap uniquement ici -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Ajouter le CSS personnalisé -->
    <style>
        /* La largeur de la modal correspond à celle de la section principale */
        .modal-content {
            max-width: 70%; /* Ajustez à 70% ou une autre valeur selon votre besoin */
            width: 100%; /* S'assure qu'elle prend toute la largeur autorisée */
            margin: auto; /* Centrer horizontalement */
        }


        /* Supprimer les soulignements des liens dans la modal */
        .modal-content a {
            text-decoration: none;
        }

        .modal-content a:hover {
            text-decoration: underline;
            color: #0056b3; /* Couleur au survol */
        }
    </style>
</head>
<body>
<div class="modal-content">
    <div class="modal-header">
        <h5 class="modal-title">Détails de la Chambre</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
    </div>
    <div class="modal-body">
        <%
            // Récupérer l'ID de la chambre depuis l'URL
            String chambreId = request.getParameter("chambre_id");

            if (chambreId != null && !chambreId.isEmpty()) {
                String selectResidentSql = "SELECT r.* FROM resident r WHERE r.chambre_id = ?";
                try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost/residence", "root", "Soukaina2003");
                     PreparedStatement ps = con.prepareStatement(selectResidentSql)) {

                    ps.setInt(1, Integer.parseInt(chambreId));
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        String nom = rs.getString("nom");
                        String prenom = rs.getString("prenom");
                        String email = rs.getString("email");
                        String telephone = rs.getString("telephone");
                        String cne = rs.getString("cne");
        %>
        <div>
            <p><strong>Nom :</strong> <%= nom %></p>
            <p><strong>Prénom :</strong> <%= prenom %></p>
            <p><strong>Email :</strong> <%= email %></p>
            <p><strong>Téléphone :</strong> <%= telephone %></p>
            <p><strong>CNE :</strong> <%= cne %></p>
        </div>
        <%
                    } else {
                        out.println("<p>Aucun résident trouvé pour cette chambre.</p>");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
    </div>
</div>
</body>
</html>
