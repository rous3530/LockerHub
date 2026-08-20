package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.locker.model.Administrador;
import mx.edu.utez.locker.model.SolicitudDto;
import mx.edu.utez.locker.dao.DaoSolicitud;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AceptadosServlet", value = "/views/admin/aceptados")
public class AceptadosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("==========================================");
        System.out.println("[ACEPTADOS-SERVLET] Petición GET recibida en /views/admin/aceptados");

        HttpSession session = request.getSession(false);
        Administrador admin = (session != null) ? (Administrador) session.getAttribute("usuario") : null;

        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
            System.out.println("[ACEPTADOS-SERVLET] Sesión inválida o rol no autorizado. Redirigiendo al login...");
            System.out.println("==========================================");
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp");
            return;
        }

        System.out.println("[ACEPTADOS-SERVLET] Usuario autenticado con rol: " + admin.getRol());

        DaoSolicitud dao = new DaoSolicitud();
        List<SolicitudDto> listaAceptados = dao.obtenerEstudiantesAceptados();

        System.out.println("[ACEPTADOS-SERVLET] Datos recuperados de la BD:");
        System.out.println(" - Total Estudiantes Aceptados encontrados: " + listaAceptados.size());
        System.out.println("[ACEPTADOS-SERVLET] Despachando a /views/admin/aceptados.jsp...");
        System.out.println("==========================================");

        request.setAttribute("listaAceptados", listaAceptados);
        request.setAttribute("totalAceptados", listaAceptados.size());
        request.setAttribute("porcentajeUso", "85%"); // O el cálculo real que tengas

        request.getRequestDispatcher("/views/admin/aceptados.jsp").forward(request, response);
    }
}