package admin.technicien;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/ModifierTechnicien")
public class ModifierTechnicien extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost/residence", "root", "Soukaina2003")) {
            String query = "DELETE FROM technicien WHERE id=?";
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("technicien.jsp");
    }
}
