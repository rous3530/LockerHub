package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.edu.utez.locker.dao.DaoSolicitud; // O el DAO que maneje las solicitudes

import java.io.IOException;

@WebServlet(name = "RegresarPendienteServlet", value = "/regresar-pendiente")
public class RegresarPendienteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recogemos el ID que manda el JavaScript (asegúrate de que coincida con el parámetro enviado)
        String idSolicitudStr = request.getParameter("idSolicitud");
        // Nota: Si en tu JS mandaste idEstudiante, cámbialo a request.getParameter("idEstudiante")

        System.out.println("=== INICIANDO PETICIÓN PARA REGRESAR A PENDIENTE ===");
        System.out.println("ID recibido: " + idSolicitudStr);

        if (idSolicitudStr != null && !idSolicitudStr.isEmpty()) {
            try {
                int idSolicitud = Integer.parseInt(idSolicitudStr);

                // Instancias tu DAO (ej. DaoSolicitud o DaoAlumno según corresponda a tu BD)
                DaoSolicitud dao = new DaoSolicitud();

                // Aquí ejecutas el método en el DAO que actualice el estatus en la BD
                // (Ej: UPDATE SOLICITUD SET ESTATUS = 'PENDIENTE' WHERE ID_SOLICITUD = ?)
                boolean actualizado = dao.regresarAStatusPendiente(idSolicitud);

                if (actualizado) {
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo actualizar el estatus en la BD");
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Falta el ID de la solicitud");
        }
    }
}