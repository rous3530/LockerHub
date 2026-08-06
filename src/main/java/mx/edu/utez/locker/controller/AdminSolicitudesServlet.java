package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.locker.dao.DaoSolicitud;
import mx.edu.utez.locker.model.Alumno;
import mx.edu.utez.locker.model.SolicitudDto;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminSolicitudesServlet", value = "/admin/solicitudes")
public class AdminSolicitudesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Validar Sesión de Administrador
        HttpSession session = request.getSession(false);
        Alumno usuario = (session != null) ? (Alumno) session.getAttribute("usuario") : null;

        if (usuario == null || !"ADMIN".equalsIgnoreCase(usuario.getRol())) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp");
            return;
        }

        DaoSolicitud dao = new DaoSolicitud();

        // Obtención de métricas e inventario
        int totalLockers = dao.obtenerTotalLockers();
        int lockersDisponibles = dao.obtenerLockersDisponibles();
        List<SolicitudDto> solicitudes = dao.obtenerSolicitudesPendientes();

        request.setAttribute("totalLockers", totalLockers);
        request.setAttribute("lockersDisponibles", lockersDisponibles);
        request.setAttribute("solicitudes", solicitudes);
        request.setAttribute("pendientesCount", solicitudes.size());

        request.getRequestDispatcher("/views/admin/inicio.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Alumno usuario = (session != null) ? (Alumno) session.getAttribute("usuario") : null;

        if (usuario == null || !"ADMIN".equalsIgnoreCase(usuario.getRol())) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        String matricula = request.getParameter("matricula");

        DaoSolicitud dao = new DaoSolicitud();
        boolean resultado = false;

        if ("preaprobar".equals(accion)) {
            resultado = dao.cambiarEstadoSolicitud(matricula, "PRE_APROBADO");
        } else if ("rechazar".equals(accion)) {
            resultado = dao.cambiarEstadoSolicitud(matricula, "RECHAZADO");
        }

        if (resultado) {
            response.sendRedirect(request.getContextPath() + "/admin/solicitudes?status=success&action=" + accion);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/solicitudes?status=error");
        }
    }
}