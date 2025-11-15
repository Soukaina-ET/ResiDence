package admin.maintenance;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.*;
@WebServlet("/SupprimerMaintenance")
public class SupprimerMaintenance extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("id");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost/residence", "root", "Soukaina2003");
            String query = "DELETE FROM maintenance WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

            response.sendRedirect("maintenance.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Erreur : " + e.getMessage());
        }
    }
}

