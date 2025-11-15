package admin.connexion;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;


public class loginAdminServlet extends HttpServlet {
    private String nom;
    private String email;
    private String password;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        nom = config.getInitParameter("nom");
        email = config.getInitParameter("email");
        password = config.getInitParameter("password");
        System.out.println("Paramètres initiaux : email = " + email + ", password = " + password);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String ema = request.getParameter("email");
        String pass = request.getParameter("password");

        // Validation des entrées
        if (ema == null || pass == null || ema.isEmpty() || pass.isEmpty()) {
            request.setAttribute("error", "Veuillez entrer votre email et votre mot de passe.");
            RequestDispatcher dispat = request.getRequestDispatcher("loginAdmin.html");
            dispat.forward(request, response);
            return;
        }

        // Vérification des informations d'identification
        if (email != null && email.equals(ema) && password != null && password.equals(pass)) {
            // Stocker les données dans la session
            HttpSession session = request.getSession();
            session.setAttribute("nom", nom);
            session.setAttribute("email", email);

            // Redirection vers le tableau de bord
            response.sendRedirect("affichageAdmin.jsp");
        } else {
            request.setAttribute("error", "Email ou mot de passe incorrect.");
            RequestDispatcher dispat = request.getRequestDispatcher("affichageAdmin.jsp");
            dispat.forward(request, response);
        }
    }


    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        doGet(request, response);
    }

}
