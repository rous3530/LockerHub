package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.locker.model.Administrador;
import mx.edu.utez.locker.model.ReporteDto;
import mx.edu.utez.locker.model.SolicitudDto;
import mx.edu.utez.locker.dao.DaoSolicitud;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "AceptadosServlet", value = "/views/admin/aceptados")
public class AceptadosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Administrador admin = (session != null) ? (Administrador) session.getAttribute("usuario") : null;

        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp");
            return;
        }

        // =========================================================================
        // NUEVO: Interceptar si la petición es para consultar un reporte vía AJAX
        // =========================================================================
        String accion = request.getParameter("accion");
        if ("verReporte".equals(accion)) {
            response.setContentType("text/plain;charset=UTF-8");
            String idSolicitudStr = request.getParameter("idSolicitud");
            PrintWriter out = response.getWriter();

            if (idSolicitudStr != null && !idSolicitudStr.isEmpty()) {
                try {
                    int idSolicitud = Integer.parseInt(idSolicitudStr);
                    DaoSolicitud dao = new DaoSolicitud();
                    ReporteDto reporte = dao.obtenerReportePorSolicitud(idSolicitud);

                    if (reporte != null && reporte.getDescripcion() != null) {
                        out.write(reporte.getDescripcion() + "\n\n(Registrado el: " + reporte.getFechaCreacion() + ")");
                    } else {
                        out.write("Sin incidencias o reportes registrados actualmente.");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.write("Error al obtener la información del reporte.");
                }
            } else {
                out.write("ID de solicitud no válido.");
            }
            return; // Detenemos la ejecución para que no intente cargar la vista JSP completa
        }

        // =========================================================================
        // Flujo normal de carga de la página de aceptados
        // =========================================================================
        System.out.println("==========================================");
        System.out.println("[ACEPTADOS-SERVLET] Petición GET recibida en /views/admin/aceptados");
        System.out.println("[ACEPTADOS-SERVLET] Usuario autenticado con rol: " + admin.getRol());

        DaoSolicitud dao = new DaoSolicitud();
        List<SolicitudDto> listaAceptados = dao.obtenerEstudiantesAceptados();

        System.out.println("[ACEPTADOS-SERVLET] Datos recuperados de la BD:");
        System.out.println(" - Total Estudiantes Aceptados encontrados: " + listaAceptados.size());
        System.out.println("[ACEPTADOS-SERVLET] Despachando a /views/admin/aceptados.jsp...");
        System.out.println("==========================================");

        request.setAttribute("listaAceptados", listaAceptados);
        request.setAttribute("totalAceptados", listaAceptados.size());
        request.setAttribute("porcentajeUso", "85%");

        request.getRequestDispatcher("/views/admin/aceptados.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Administrador admin = (session != null) ? (Administrador) session.getAttribute("usuario") : null;

        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp");
            return;
        }

        String idEstudiante = request.getParameter("estudianteId"); // idSolicitud
        String textoReporte = request.getParameter("reporte");

        System.out.println("==========================================");
        System.out.println("[ACEPTADOS-SERVLET] Procesando guardado de reporte...");
        System.out.println(" - ID Estudiante/Solicitud: " + idEstudiante);
        System.out.println(" - Descripción: " + textoReporte);
        System.out.println("==========================================");

        try {
            DaoSolicitud dao = new DaoSolicitud();
            boolean guardado = dao.guardarReporte(idEstudiante, textoReporte);

            if (guardado) {
                response.sendRedirect(request.getContextPath() + "/views/admin/aceptados?exito=reporte_guardado");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/admin/aceptados?error=error_guardar");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/admin/aceptados?error=excepcion");
        }
    }
}