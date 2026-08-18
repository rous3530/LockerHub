package mx.edu.utez.locker.controller;

import mx.edu.utez.locker.dao.DaoSolicitud;
import mx.edu.utez.locker.model.Administrador;
import mx.edu.utez.locker.model.SolicitudDto;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/views/admin/inicio")
public class AdminSolicitudesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("\n==========================================");
        System.out.println("[ADMIN-SERVLET] Petición GET recibida en /views/admin/inicio");

        HttpSession session = request.getSession(false);
        Administrador usuario = (session != null) ? (Administrador) session.getAttribute("usuario") : null;

        if (usuario == null || !"ADMIN".equalsIgnoreCase(usuario.getRol())) {
            System.out.println("[ADMIN-SERVLET] Acceso denegado. Usuario no autenticado o no es ADMIN.");
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp");
            return;
        }

        System.out.println("[ADMIN-SERVLET] Usuario autenticado: " + usuario.getNombres() + " | Rol: " + usuario.getRol());

        DaoSolicitud dao = new DaoSolicitud();

        // Cargar información desde la BD
        List<SolicitudDto> solicitudes = dao.obtenerSolicitudesPendientes();
        int totalLockers = dao.obtenerTotalLockers();
        int lockersDisponibles = dao.obtenerLockersDisponibles();

        // Muestra de datos recuperados en consola
        System.out.println("[ADMIN-SERVLET] Datos recuperados de la BD:");
        System.out.println(" - Total Lockers: " + totalLockers);
        System.out.println(" - Lockers Disponibles: " + lockersDisponibles);

        if (solicitudes != null) {
            System.out.println(" - Solicitudes pendientes encontradas: " + solicitudes.size());
            for (SolicitudDto s : solicitudes) {
                System.out.println("   * [" + s.getMatricula() + "] " + s.getNombreCompleto() + " (" + s.getCarrera() + ")");
            }
        } else {
            System.out.println(" - Solicitudes: NULL (Lista vacía o error en DAO)");
        }

        // Enviar datos al JSP
        request.setAttribute("solicitudes", solicitudes);
        request.setAttribute("totalLockers", totalLockers);
        request.setAttribute("lockersDisponibles", lockersDisponibles);
        request.setAttribute("pendientesCount", solicitudes != null ? solicitudes.size() : 0);

        System.out.println("[ADMIN-SERVLET] Despachando a /views/admin/inicio.jsp...");
        System.out.println("==========================================\n");

        request.getRequestDispatcher("/views/admin/inicio.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("\n==========================================");
        System.out.println("[ADMIN-SERVLET] Petición POST recibida en /views/admin/inicio");

        HttpSession session = request.getSession(false);
        Administrador usuario = (session != null) ? (Administrador) session.getAttribute("usuario") : null;

        if (usuario == null || !"ADMIN".equalsIgnoreCase(usuario.getRol())) {
            System.out.println("[ADMIN-SERVLET] POST rechazado: Sesión inválida.");
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        String matricula = request.getParameter("matricula");

        System.out.println("[ADMIN-SERVLET] Procesando acción:");
        System.out.println(" - Acción: " + accion);
        System.out.println(" - Matrícula objetivo: " + matricula);

        DaoSolicitud dao = new DaoSolicitud();
        boolean resultado = false;

        if ("preaprobar".equals(accion)) {
            resultado = dao.cambiarEstadoSolicitud(matricula, "PRE_ACEPTADA");
        } else if ("rechazar".equals(accion)) {
            resultado = dao.cambiarEstadoSolicitud(matricula, "RECHAZADA");
        }

        System.out.println("[ADMIN-SERVLET] Resultado de actualización en BD: " + (resultado ? "ÉXITO" : "FALLO"));
        System.out.println("==========================================\n");

        response.sendRedirect(request.getContextPath() + "/views/admin/inicio?status=" + (resultado ? "success" : "error") + "&action=" + accion);
    }
}