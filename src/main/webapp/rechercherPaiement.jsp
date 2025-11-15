<%@ page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Boxicons -->
    <link href='https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="dashboard.css">
    <title>Paiement</title>
    <style>
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 10% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 50%;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.2);
        }

        .modal .close {
            color: red !important ; /* Changer la couleur en rouge directement */
            font-size: 30px; /* Augmenter la taille du X */
            font-weight: bold;
            position: absolute; /* Positionner absolument dans le coin supérieur droit */
            top: 10px;
            right: 10px;
            cursor: pointer;
        }
        .close:hover,
        .close:focus {
            color: darkred !important;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
<!-- SIDEBAR -->
<section id="sidebar">
    <a href="#" class="brand">
        <i class='bx bxs-home'></i>
        <span class="text">RESIDET</span>
    </a>
    <ul class="side-menu top">
        <li class="active">
            <a href="affichageAdmin.jsp">
                <i class='bx bxs-dashboard' ></i>
                <span class="text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="Chambre.jsp">
                <i class='bx bx-bed'></i>
                <span class="text">Chambres</span>
            </a>
        </li>
        <li>
            <a href="residents.jsp">
                <i class='bx bxs-user-detail'></i>
                <span class="text">Résidents</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class="bx bx-credit-card"></i>
                <span class="text">Paiement</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class="bx bx-wrench"></i>
                <span class="text">Maintenance</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class="bx bx-line-chart"></i>
                <span class="text">Statistiques</span>
            </a>
        </li>
        <li>
            <a href="demandes.jsp">
                <i class='bx bx-user-plus'></i>
                <span class="text">Demandes d'inscription</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-group' ></i>
                <span class="text">Admins</span>
            </a>
        </li>
    </ul>
    <ul class="side-menu">

        <li>
            <a href="#">
                <i class='bx bxs-cog' ></i>
                <span class="text">Paramètre</span>
            </a>
        </li>
        <li>
            <a href="#" class="logout">
                <i class='bx bxs-log-out-circle' ></i>
                <span class="text">Déconnexion</span>
            </a>
        </li>
    </ul>
</section>
<!-- SIDEBAR -->



<!-- CONTENT -->
<section id="content">
    <!-- NAVBAR -->
    <nav>
        <i class='bx bx-menu' ></i>
        <a href="#" class="nav-link">Categories</a>
        <form method="GET" action="rechercherPaiement.jsp">
            <div class="form-input">
                <input type="text" name="rech" id="rech" placeholder="Rechercher...">
                <button type="submit" class="search-btn" value="Rechercher"><i class='bx bx-search' ></i></button>
            </div>
        </form>
        <input type="checkbox" id="switch-mode" hidden>
        <label for="switch-mode" class="switch-mode"></label>
        <a href="#" class="notification">
            <i class='bx bxs-bell' ></i>
            <span class="num">8</span>
        </a>
        <a href="#" class="profile">
            <img src="images/resident.png">
        </a>
    </nav>
    <!-- NAVBAR -->

    <!-- MAIN -->
    <main>
        <h1>Résultats de recherche:</h1>
        <button id="addChambreBtn" class="add-student-btn" onclick="openAddResidentModal()">Ajouter Paiement </button>
        <!-- Modal for adding resident -->
        <div id="addResidentModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h2>Ajouter Paiement</h2>
                <form class="add" method="POST" action="InsererPaiement">

                    <label for="resident_id">ID Résident :</label>
                    <input type="text" id="resident_id" name="resident_id" required><br>

                    <label for="chambre_id">ID Chambre :</label>
                    <input type="text" id="chambre_id" name="chambre_id"><br>

                    <label for="montant_due">Montant Due :</label>
                    <input type="number" id="montant_due" name="montant_due" step="0.01" required><br>

                    <label for="montant_paye">Montant Payé :</label>
                    <input type="number" id="montant_paye" name="montant_paye" step="0.01" required><br>

                    <label for="mode_paiement">Mode de Paiement :</label>
                    <select name="mode_paiement" id="mode_paiement">
                        <option value="Espèce">Espèce</option>
                        <option value="Carte">Carte</option>
                    </select><br>

                    <label for="commentaire">Commentaire :</label>
                    <textarea name="commentaire" id="commentaire"></textarea><br>

                    <input type="submit" value="Effectuer le Paiement">
                </form>
            </div>
        </div>
        <div class="head-title">
            <div class="left">
                <h2>Résultats de la recherche :</h2>
            </div>
            <table border="1">
                <thead>
                <tr>
                    <th>ID Paiement</th>
                    <th>ID Résident</th>
                    <th>ID Chambre</th>
                    <th>Montant Due</th>
                    <th>Montant Payé</th>
                    <th>Date de Paiement</th>
                    <th>Mode de Paiement</th>
                    <th>Statut</th>
                    <th>Commentaire</th>
                    <th colspan="3">Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    String rech = request.getParameter("rech"); // Obtenir la valeur de recherche
                    String selectPaiements = "SELECT * FROM paiements WHERE id LIKE ? OR resident_id LIKE ? OR chambre_id LIKE ? " +
                            "OR montant_due LIKE ? OR montant_paye LIKE ? OR date_paiement LIKE ? " +
                            "OR mode_paiement LIKE ? OR statut LIKE ?";
                    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost/residence", "root", "Soukaina2003");
                         PreparedStatement ps = con.prepareStatement(selectPaiements)) {

                        // Remplir les placeholders avec la valeur de recherche
                        for (int i = 1; i <= 8; i++) {
                            ps.setString(i, "%" + rech + "%");
                        }

                        try (ResultSet rs = ps.executeQuery()) {
                            if (!rs.isBeforeFirst()) {
                                out.println("<tr><td colspan='11'>Aucun paiement trouvé.</td></tr>");
                            } else {
                                while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getInt("resident_id") %></td>
                    <td><%= rs.getInt("chambre_id") %></td>
                    <td><%= rs.getDouble("montant_due") %></td>
                    <td><%= rs.getDouble("montant_paye") %></td>
                    <td><%= rs.getTimestamp("date_paiement") %></td>
                    <td><%= rs.getString("mode_paiement") %></td>
                    <td><%= rs.getString("statut") %></td>
                    <td><%= rs.getString("commentaire") %></td>
                    <td><a href="EditPaiement?id=<%= rs.getInt("id") %>"><ion-icon name="pencil-outline"></ion-icon></a></td>
                    <td><a href="DeletePaiement?id=<%= rs.getInt("id") %>"><ion-icon name="trash-outline"></ion-icon></a></td>
                    <td><a href="GenererRecu?id=<%= rs.getInt("id") %>"><ion-icon name="download"></ion-icon></a></td>
                </tr>
                <%
                                }
                            }
                        }
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='11'>Erreur : " + e.getMessage() + "</td></tr>");
                    }
                %>
                </tbody>
            </table>
            <a href="paiement.jsp">Retour</a>
        </div>
        <div id="modificationModal" class="modal">
            <div class="modal-content" id="modal-content">
                <button type="button" class="close" onclick="closeModal()">&times;</button>
                <!-- Le formulaire sera inséré ici dynamiquement -->
            </div>
        </div>
    </main>
</section>
</body>
<script>
    function openAddResidentModal() {
        const modal = document.getElementById("addResidentModal");
        modal.style.display = "block";
    }

    function closeModal() {
        const modal = document.getElementById("addResidentModal");
        modal.style.display = "none";
    }

    document.querySelector('.add').addEventListener('submit', function(event) {
        let montantDue = parseFloat(document.getElementById('montant_due').value);
        let montantPaye = parseFloat(document.getElementById('montant_paye').value);

        if (montantPaye > montantDue) {
            alert("Le montant payé ne peut pas être supérieur au montant dû.");
            event.preventDefault(); // Empêche l'envoi du formulaire
        }
    });





    function openModal(paiementId) {

        // Récupérer les données de paiement depuis la base de données via une requête AJAX
        fetch('editPaiementForm.jsp?id=' + paiementId)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Erreur réseau lors du chargement du formulaire');
                }
                return response.text();
            })
            .then(data => {
                document.getElementById("modal-content").innerHTML = data;
                document.getElementById("modificationModal").style.display = "block"; // Show the modal

                // Attacher l'événement pour fermer le modal après l'insertion du contenu
                const closeModal = document.getElementById("closeModal");
                closeModal.onclick = function () {
                    document.getElementById("modificationModal").style.display = "none";
                    document.getElementById("formulaireContainer").innerHTML = ""; // Réinitialiser le contenu
                };
            })
            .catch(error => {
                console.error("Erreur lors du chargement du formulaire : ", error);
            });
    }
    function closeModal() {
        const modal = document.getElementById("modificationModal");
        modal.style.display = "none";
    }



</script>
<script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>

<script src="script.js"></script>
</html>