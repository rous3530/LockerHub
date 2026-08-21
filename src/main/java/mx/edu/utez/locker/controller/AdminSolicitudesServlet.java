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

        // --- AQUÍ INICIA EL RASTREO DEL GET ---
        System.out.println("\n==========================================");
        System.out.println("[ADMIN-SERVLET] Petición GET recibida en /views/admin/inicio");

        HttpSession session = request.getSession(false);
        Administrador usuario = (session != null) ? (Administrador) session.getAttribute("usuario") : null;

        if (usuario == null || !"ADMIN".equalsIgnoreCase(usuario.getRol())) {
            System.out.println("[ADMIN-SERVLET] ⛔ Acceso denegado: Usuario no autenticado o no es ADMIN.");
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp");
            return;
        }

        System.out.println("[ADMIN-SERVLET] ✓ Usuario autenticado: " + usuario.getNombres() + " | Rol: " + usuario.getRol());

        // Capturar el parámetro de filtro
        String estatusSeleccionado = request.getParameter("estatus");
        if (estatusSeleccionado == null || estatusSeleccionado.isEmpty()) {
            estatusSeleccionado = "PENDIENTE"; // Valor por defecto
        }
        System.out.println("[ADMIN-SERVLET] 🔍 Estatus solicitado para filtrado: [" + estatusSeleccionado + "]");

        DaoSolicitud dao = new DaoSolicitud();

        // Cargar información desde la BD
        List<SolicitudDto> solicitudes = dao.obtenerSolicitudesPorEstado(estatusSeleccionado);
        int totalLockers = dao.obtenerTotalLockers();
        int lockersDisponibles = dao.obtenerLockersDisponibles();

        List<SolicitudDto> listaPendientes = dao.obtenerSolicitudesPendientes();
        int pendientesCount = (listaPendientes != null) ? listaPendientes.size() : 0;

        // Muestra detallada de datos recuperados en consola
        System.out.println("[ADMIN-SERVLET] 📊 Métricas obtenidas de la BD:");
        System.out.println(" - Total Lockers: " + totalLockers);
        System.out.println(" - Lockers Disponibles: " + lockersDisponibles);
        System.out.println(" - Conteo Pendientes (Métrica): " + pendientesCount);

        if (solicitudes != null) {
            System.out.println(" - Solicitudes encontradas para '" + estatusSeleccionado + "': " + solicitudes.size());
            for (SolicitudDto s : solicitudes) {
                System.out.println("   * [Matrícula: " + s.getMatricula() + "] " + s.getNombreCompleto() + " | Estado actual: " + s.getEstado() + " | Casillero: " + s.getCasilleroCodigo());
            }
        } else {
            System.out.println(" - Solicitudes: NULL (Lista vacía o error en DAO)");
        }

        // Enviar datos al JSP
        request.setAttribute("solicitudes", solicitudes);
        request.setAttribute("totalLockers", totalLockers);
        request.setAttribute("lockersDisponibles", lockersDisponibles);
        request.setAttribute("pendientesCount", pendientesCount);

        System.out.println("[ADMIN-SERVLET] 🚀 Despachando a /views/admin/inicio.jsp...");
        System.out.println("==========================================\n");

        request.getRequestDispatcher("/views/admin/inicio.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // --- AQUÍ INICIA EL RASTREO DEL POST ---
        System.out.println("\n==========================================");
        System.out.println("[ADMIN-SERVLET] 📥 Petición POST recibida (Acción de administrador)");

        HttpSession session = request.getSession(false);
        Administrador usuario = (session != null) ? (Administrador) session.getAttribute("usuario") : null;

        if (usuario == null || !"ADMIN".equalsIgnoreCase(usuario.getRol())) {
            System.out.println("[ADMIN-SERVLET] ⛔ POST rechazado: Sesión inválida o sin permisos.");
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        String matricula = request.getParameter("matricula");

        System.out.println("[ADMIN-SERVLET] ⚙️ Parámetros recibidos:");
        System.out.println(" - Acción solicitada: [" + accion + "]");
        System.out.println(" - Matrícula objetivo: [" + matricula + "]");

        DaoSolicitud dao = new DaoSolicitud();
        boolean resultado = false;
        String estatusDestino = "PENDIENTE"; // Por defecto

        if ("preaprobar".equals(accion)) {
            System.out.println("[ADMIN-SERVLET] Ejecutando cambio a PRE_ACEPTADA...");
            resultado = dao.cambiarEstadoSolicitud(matricula, "PRE_ACEPTADA");
            estatusDestino = "PRE_ACEPTADA";
        } else if ("rechazar".equals(accion)) {
            System.out.println("[ADMIN-SERVLET] Ejecutando cambio a RECHAZADA...");
            resultado = dao.cambiarEstadoSolicitud(matricula, "RECHAZADA");
            estatusDestino = "RECHAZADA";
        } else if ("reincorporar".equals(accion)) {
            System.out.println("[ADMIN-SERVLET] Ejecutando cambio a PENDIENTE (Reincorporación)...");
            resultado = dao.cambiarEstadoSolicitud(matricula, "PENDIENTE");
            estatusDestino = "PENDIENTE";
        } else {
            System.out.println("[ADMIN-SERVLET] ⚠️ Advertencia: La acción '" + accion + "' no es reconocida.");
        }

        System.out.println("[ADMIN-SERVLET] 💾 Resultado de actualización en Oracle: " + (resultado ? "✅ ÉXITO (Filas actualizadas)" : "❌ FALLO (No se actualizó ningún registro)"));
        System.out.println("[ADMIN-SERVLET] 🔄 Redirigiendo de vuelta a /views/admin/inicio con estatus: " + estatusDestino);
        System.out.println("==========================================\n");

        // Redirigimos conservando el estatus correspondiente para que la vista se mantenga en la pestaña correcta
        response.sendRedirect(request.getContextPath() + "/views/admin/inicio?estatus=" + estatusDestino + "&status=" + (resultado ? "success" : "error") + "&action=" + accion);
    }
}