package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.locker.dao.DaoSolicitud;
import mx.edu.utez.locker.model.Administrador;
import mx.edu.utez.locker.model.CasilleroDto;
import mx.edu.utez.locker.model.EdificioDto;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "GestionLockerServlet", value = "/admin/gestionLocker")
public class GestionLockerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);
        Administrador admin = (sesion != null) ? (Administrador) sesion.getAttribute("usuario") : null;

        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
            return;
        }

        try {
            DaoSolicitud dao = new DaoSolicitud();
            List<EdificioDto> listaEdificios = dao.obtenerEdificios();
            List<CasilleroDto> listaCasilleros = dao.obtenerTodosLosCasilleros();

            // Aseguramos que las listas no sean nulas aunque la BD esté vacía
            request.setAttribute("listaEdificios", (listaEdificios != null ? listaEdificios : new java.util.ArrayList<>()));
            request.setAttribute("listaCasilleros", (listaCasilleros != null ? listaCasilleros : new java.util.ArrayList<>()));

// Cálculo de métricas basadas en la lista de casilleros
            int totalCasilleros = listaCasilleros.size();
            int ocupados = 0;
            int disponibles = 0;
            int mantenimiento = 0;

            for (CasilleroDto c : listaCasilleros) {
                if (c.getEstado() != null) {
                    String est = c.getEstado().toUpperCase();
                    if (est.contains("OCUPADO")) {
                        ocupados++;
                    } else if (est.contains("DISPONIBLE")) {
                        disponibles++;
                    } else if (est.contains("MANTENIMIENTO")) {
                        mantenimiento++;
                    }
                }
            }

            double porcentajeLibre = (totalCasilleros > 0) ? Math.round(((double) disponibles / totalCasilleros) * 100.0) : 0.0;

            // Enviar los atributos al JSP
            request.setAttribute("totalCasilleros", totalCasilleros);
            request.setAttribute("ocupados", ocupados);
            request.setAttribute("disponibles", disponibles);
            request.setAttribute("mantenimiento", mantenimiento);
            request.setAttribute("porcentajeLibre", porcentajeLibre);



            // Impresión de logs
            System.out.println("[LOCKER-SERVLET] Despachando a JSP con " + (listaCasilleros != null ? listaCasilleros.size() : 0) + " casilleros.");

            request.getRequestDispatcher("/views/admin/gestionLocker.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("[LOCKER-SERVLET] ERROR CRÍTICO EN DOGET: ");
            e.printStackTrace(); // Esto imprimirá en consola EXACTAMENTE la línea que falla en el JSP
            response.sendError(500, "Error procesando la vista de gestión");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);
        Administrador admin = (sesion != null) ? (Administrador) sesion.getAttribute("usuario") : null;

        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
            return;
        }

        String codigoCasillero = request.getParameter("codigoCasillero");
        String nuevoEstado = request.getParameter("nuevoEstado");

        System.out.println("==================================================");
        System.out.println("[LOCKER-SERVLET] Petición POST recibida (Actualización de Casillero)");
        System.out.println("[LOCKER-SERVLET] Administrador: " + admin.getNombre());
        System.out.println("[LOCKER-SERVLET] Casillero objetivo: [" + codigoCasillero + "]");
        System.out.println("[LOCKER-SERVLET] Nuevo estatus solicitado: [" + nuevoEstado + "]");
        System.out.println("==================================================");

        try {
            DaoSolicitud dao = new DaoSolicitud();
            boolean actualizado = dao.actualizarEstadoCasillero(codigoCasillero, nuevoEstado);

            if (actualizado) {
                System.out.println("[LOCKER-SERVLET] ✔️ Casillero actualizado correctamente en la BD.");
                response.sendRedirect(request.getContextPath() + "/admin/gestionLocker?exito=actualizado");
            } else {
                System.out.println("[LOCKER-SERVLET] ❌ No se pudo actualizar el casillero.");
                response.sendRedirect(request.getContextPath() + "/admin/gestionLocker?error=fallo_actualizacion");
            }

        } catch (Exception e) {
            System.err.println("[LOCKER-SERVLET] ❌ Excepción capturada en doPost:");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/gestionLocker?error=excepcion");
        }
    }
}