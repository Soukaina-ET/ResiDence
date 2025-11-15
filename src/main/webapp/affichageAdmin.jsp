<%@ page contentType="text/html" pageEncoding="UTF-8"  %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Statistiques</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <link href='https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css' rel='stylesheet'>
  <link rel="stylesheet" href="dashboard.css">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      overflow: hidden;
      height: 100vh;
    }

    #content main {
      height: calc(100vh - 60px);
      overflow: hidden;
      padding: 15px;
    }

    .stats-wrapper {
      height: 100%;
      display: flex;
      flex-direction: column;
      gap: 15px;
    }

    .head-title {
      margin-bottom: 0;
    }

    .head-title h1 {
      color: #1e3a8a;
      font-size: 24px;
      font-weight: 700;
      margin-bottom: 5px;
    }

    .subtitle {
      color: #64748b;
      font-size: 13px;
      margin-bottom: 0;
    }

    .summary-cards {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 12px;
    }

    .summary-card {
      background: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%);
      border-radius: 12px;
      padding: 15px;
      box-shadow: 0 4px 15px rgba(30, 64, 175, 0.2);
      border: none;
      color: white;
      transition: transform 0.3s ease;
    }

    .summary-card:hover {
      transform: translateY(-3px);
    }

    .summary-card:nth-child(2) {
      background: linear-gradient(135deg, #0891b2 0%, #06b6d4 100%);
    }

    .summary-card:nth-child(3) {
      background: linear-gradient(135deg, #0284c7 0%, #0ea5e9 100%);
    }

    .summary-card:nth-child(4) {
      background: linear-gradient(135deg, #7c3aed 0%, #8b5cf6 100%);
    }

    .summary-card h4 {
      color: rgba(255, 255, 255, 0.9);
      font-size: 11px;
      font-weight: 500;
      margin: 0 0 8px 0;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .summary-value {
      font-size: 24px;
      font-weight: 700;
      color: white;
      margin: 0;
    }

    .summary-label {
      font-size: 10px;
      color: rgba(255, 255, 255, 0.7);
      margin-top: 4px;
    }

    .stats-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 12px;
      flex: 1;
      min-height: 0;
    }

    .stat-card {
      background: white;
      border-radius: 12px;
      padding: 15px;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
      display: flex;
      flex-direction: column;
      border-top: 3px solid #3b82f6;
      position: relative;
      overflow: hidden;
    }

    .stat-card:nth-child(2) {
      border-top-color: #06b6d4;
    }

    .stat-card:nth-child(3) {
      border-top-color: #0ea5e9;
    }

    .stat-card:nth-child(4) {
      border-top-color: #8b5cf6;
    }

    .stat-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
    }

    .stat-header h3 {
      color: #1e3a8a;
      font-size: 13px;
      font-weight: 600;
      margin: 0;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .stat-icon {
      width: 35px;
      height: 35px;
      background: linear-gradient(135deg, #3b82f6 0%, #1e40af 100%);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      color: white;
    }

    .stat-card:nth-child(2) .stat-icon {
      background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
    }

    .stat-card:nth-child(3) .stat-icon {
      background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
    }

    .stat-card:nth-child(4) .stat-icon {
      background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
    }

    .chart-wrapper {
      flex: 1;
      position: relative;
      min-height: 0;
    }

    .chart-wrapper canvas {
      max-height: 100% !important;
      width: 100% !important;
    }

    .loading {
      text-align: center;
      padding: 50px;
      color: #64748b;
    }

    .loading i {
      font-size: 48px;
      color: #3b82f6;
      animation: spin 2s linear infinite;
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
  </style>
</head>
<body>
<section id="sidebar">
  <a href="#" class="brand">
    <i class='bx bxs-home'></i>
    <span class="text">RESIDET</span>
  </a>
  <ul class="side-menu top">
    <li>
      <a href="affichageAdmin.jsp">
        <i class='bx bxs-dashboard'></i>
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
      <a href="paiement.jsp">
        <i class="bx bx-credit-card"></i>
        <span class="text">Paiement</span>
      </a>
    </li>
    <li>
      <a href="maintenance.jsp">
        <i class="bx bx-wrench"></i>
        <span class="text">Maintenance</span>
      </a>
    </li>
    <li class="active">
      <a href="statistiques.jsp">
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
      <a href="admins.jsp">
        <i class='bx bxs-group'></i>
        <span class="text">Admins</span>
      </a>
    </li>
  </ul>
  <ul class="side-menu">
    <li>
      <a href="parametre.jsp">
        <i class='bx bxs-cog'></i>
        <span class="text">Paramètre</span>
      </a>
    </li>
    <li>
      <a href="deconnexion.jsp" class="logout">
        <i class='bx bxs-log-out-circle'></i>
        <span class="text">Déconnexion</span>
      </a>
    </li>
  </ul>
</section>

<section id="content">
  <nav>
    <i class='bx bx-menu'></i>
    <a href="#" class="nav-link">Categories</a>
    <form method="GET" action="rechercher.jsp">
      <div class="form-input">
        <input type="text" name="rech" id="rech" placeholder="Rechercher...">
        <button type="submit" class="search-btn" value="Rechercher"><i class='bx bx-search'></i></button>
      </div>
    </form>
    <input type="checkbox" id="switch-mode" hidden>
    <label for="switch-mode" class="switch-mode"></label>
    <a href="#" class="notification">
      <i class='bx bxs-bell'></i>
      <span class="num">8</span>
    </a>
    <a href="#" class="profile">
      <img src="images/resident.png">
    </a>
  </nav>

  <main>
    <div id="loading" class="loading">
      <i class='bx bx-loader-alt'></i>
      <p>Chargement des statistiques...</p>
    </div>

    <div id="statsContent" class="stats-wrapper" style="display: none;">
      <div class="head-title">
        <div class="left">
          <h1>📊 Tableau de Bord</h1>
          <p class="subtitle">Vue d'ensemble des statistiques de la résidence</p>
        </div>
      </div>

      <div class="summary-cards">
        <div class="summary-card">
          <h4>Total Résidents</h4>
          <p class="summary-value" id="totalResidents">0</p>
          <p class="summary-label">Résidents actifs</p>
        </div>
        <div class="summary-card">
          <h4>Chambres Disponibles</h4>
          <p class="summary-value" id="chambresDisponibles">0</p>
          <p class="summary-label">Prêtes à l'occupation</p>
        </div>
        <div class="summary-card">
          <h4>Paiements en Attente</h4>
          <p class="summary-value" id="paiementsAttente">0 MAD</p>
          <p class="summary-label">Montant total dû</p>
        </div>
        <div class="summary-card">
          <h4>Maintenance Active</h4>
          <p class="summary-value" id="maintenanceActive">0</p>
          <p class="summary-label">Demandes en cours</p>
        </div>
      </div>

      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-header">
            <h3>Chambres</h3>
            <div class="stat-icon">
              <i class='bx bx-bed'></i>
            </div>
          </div>
          <div class="chart-wrapper">
            <canvas id="chambresChart"></canvas>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-header">
            <h3>Résidents</h3>
            <div class="stat-icon">
              <i class='bx bxs-user-detail'></i>
            </div>
          </div>
          <div class="chart-wrapper">
            <canvas id="residentsChart"></canvas>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-header">
            <h3>Paiements</h3>
            <div class="stat-icon">
              <i class='bx bx-credit-card'></i>
            </div>
          </div>
          <div class="chart-wrapper">
            <canvas id="paiementsChart"></canvas>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-header">
            <h3>Maintenance</h3>
            <div class="stat-icon">
              <i class='bx bx-wrench'></i>
            </div>
          </div>
          <div class="chart-wrapper">
            <canvas id="maintenanceChart"></canvas>
          </div>
        </div>
      </div>
    </div>
  </main>
</section>

<script>
  Chart.defaults.font.family = "'Inter', sans-serif";
  Chart.defaults.font.size = 11;
  Chart.defaults.color = '#64748b';

  fetch('StatistiquesServlet')
          .then(response => response.json())
          .then(data => {
            document.getElementById('loading').style.display = 'none';
            document.getElementById('statsContent').style.display = 'flex';

            if (data.residents && data.residents.Total) {
              document.getElementById('totalResidents').textContent = data.residents.Total;
            }

            if (data.chambres && data.chambres.Disponible) {
              document.getElementById('chambresDisponibles').textContent = data.chambres.Disponible;
            }

            if (data.paiements && data.paiements['En attente']) {
              document.getElementById('paiementsAttente').textContent =
                      Math.round(data.paiements['En attente']) + ' MAD';
            }

            if (data.maintenance) {
              const maintenanceActive = Object.values(data.maintenance)
                      .reduce((sum, val) => sum + (typeof val === 'number' ? val : 0), 0);
              document.getElementById('maintenanceActive').textContent = maintenanceActive;
            }

            const chambresCtx = document.getElementById('chambresChart').getContext('2d');
            new Chart(chambresCtx, {
              type: 'bar',
              data: {
                labels: Object.keys(data.chambres),
                datasets: [{
                  label: 'Chambres',
                  data: Object.values(data.chambres),
                  backgroundColor: ['#3b82f6', '#06b6d4', '#0ea5e9'],
                  borderRadius: 6,
                  barThickness: 30
                }]
              },
              options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                  legend: { display: false },
                  tooltip: {
                    backgroundColor: 'rgba(30, 64, 175, 0.9)',
                    padding: 10,
                    borderRadius: 6
                  }
                },
                scales: {
                  x: { beginAtZero: true, grid: { display: false } },
                  y: { grid: { display: false } }
                }
              }
            });

            const residentsCtx = document.getElementById('residentsChart').getContext('2d');
            new Chart(residentsCtx, {
              type: 'doughnut',
              data: {
                labels: Object.keys(data.residents),
                datasets: [{
                  data: Object.values(data.residents),
                  backgroundColor: ['#3b82f6', '#06b6d4', '#0ea5e9'],
                  borderWidth: 0,
                  hoverOffset: 8
                }]
              },
              options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '65%',
                plugins: {
                  legend: {
                    position: 'bottom',
                    labels: { padding: 10, usePointStyle: true, font: { size: 10 } }
                  },
                  tooltip: {
                    backgroundColor: 'rgba(30, 64, 175, 0.9)',
                    padding: 10,
                    borderRadius: 6
                  }
                }
              }
            });

            const paiementsCtx = document.getElementById('paiementsChart').getContext('2d');
            new Chart(paiementsCtx, {
              type: 'doughnut',
              data: {
                labels: Object.keys(data.paiements),
                datasets: [{
                  data: Object.values(data.paiements),
                  backgroundColor: ['#3b82f6', '#06b6d4', '#0ea5e9'],
                  borderWidth: 0,
                  hoverOffset: 8
                }]
              },
              options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '65%',
                plugins: {
                  legend: {
                    position: 'bottom',
                    labels: { padding: 10, usePointStyle: true, font: { size: 10 } }
                  },
                  tooltip: {
                    backgroundColor: 'rgba(30, 64, 175, 0.9)',
                    padding: 10,
                    borderRadius: 6,
                    callbacks: {
                      label: function(context) {
                        return context.label + ': ' + Math.round(context.parsed) + ' MAD';
                      }
                    }
                  }
                }
              }
            });

            const maintenanceCtx = document.getElementById('maintenanceChart').getContext('2d');
            new Chart(maintenanceCtx, {
              type: 'bar',
              data: {
                labels: Object.keys(data.maintenance),
                datasets: [{
                  label: 'Demandes',
                  data: Object.values(data.maintenance),
                  backgroundColor: ['#3b82f6', '#8b5cf6'],
                  borderRadius: 6,
                  barThickness: 40
                }]
              },
              options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                  legend: { display: false },
                  tooltip: {
                    backgroundColor: 'rgba(30, 64, 175, 0.9)',
                    padding: 10,
                    borderRadius: 6
                  }
                },
                scales: {
                  y: { beginAtZero: true, grid: { color: '#f1f5f9' } },
                  x: { grid: { display: false } }
                }
              }
            });
          })
          .catch(error => {
            console.error('Erreur:', error);
            document.getElementById('loading').innerHTML =
                    '<i class="bx bx-error"></i><p>Erreur lors du chargement des statistiques</p>';
          });
</script>

<script src="script.js"></script>
</body>
</html>