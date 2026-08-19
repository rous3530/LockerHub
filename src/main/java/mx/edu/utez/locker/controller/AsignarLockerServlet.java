package mx.edu.utez.locker.controller;

import mx.edu.utez.locker.dao.DaoSolicitud;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "AsignarLockerServlet", urlPatterns = {"/asignar-locker"})
public class AsignarLockerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        try {
            // 1. Recibir los parámetros enviados desde JavaScript
            String idSolicitudStr = request.getParameter("idSolicitud");
            String idLockerStr = request.getParameter("idLocker");

            if (idSolicitudStr == null || idLockerStr == null || idSolicitudStr.isEmpty() || idLockerStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"message\": \"Faltan parámetros requeridos.\"}");
                return;
            }

            int idSolicitud = Integer.parseInt(idSolicitudStr);
            int idLocker = Integer.parseInt(idLockerStr);

            // 2. Llamar al DAO para hacer el UPDATE en la base de datos Oracle
            DaoSolicitud daoSolicitud = new DaoSolicitud();
            boolean actualizado = daoSolicitud.asignarLockerASolicitud(idSolicitud, idLocker);

            if (actualizado) {
                response.setStatus(HttpServletResponse.SC_OK);
                out.print("{\"success\": true, \"message\": \"Casillero asignado correctamente.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\": false, \"message\": \"No se pudo actualizar la base de datos.\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Los IDs deben ser numéricos.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"Error en el servidor: " + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }
}