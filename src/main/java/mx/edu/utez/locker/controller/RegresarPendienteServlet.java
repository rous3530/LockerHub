package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.edu.utez.locker.dao.DaoSolicitud; // O el DAO donde gestiones las solicitudes

import java.io.IOException;

@WebServlet(name = "RegresarPendienteServlet", value = "/regresar-pendiente")
public class RegresarPendienteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idEstudianteStr = request.getParameter("idEstudiante");

        if (idEstudianteStr != null && !idEstudianteStr.isEmpty()) {
            try {
                int idEstudiante = Integer.parseInt(idEstudianteStr);

                DaoSolicitud dao = new DaoSolicitud();
                boolean actualizado = dao.cambiarEstatusPendiente(idEstudiante);

                if (actualizado) {
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo actualizar la solicitud");
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de estudiante inválido");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Falta el ID del estudiante");
        }
    }
}