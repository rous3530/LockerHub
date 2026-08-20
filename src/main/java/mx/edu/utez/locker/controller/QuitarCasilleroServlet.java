package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.edu.utez.locker.dao.DaoLocker;

import java.io.IOException;

@WebServlet(name = "QuitarCasilleroServlet", value = "/quitar-casillero")
public class QuitarCasilleroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recibimos el parámetro como idSolicitud (el cual viene desde el botón en el JSP)
        String idSolicitudStr = request.getParameter("idSolicitud");

        System.out.println("=== INICIANDO PETICIÓN PARA QUITAR CASILLERO ===");
        System.out.println("Parámetro recibido idSolicitud: " + idSolicitudStr);

        if (idSolicitudStr != null && !idSolicitudStr.isEmpty()) {
            try {
                int idSolicitud = Integer.parseInt(idSolicitudStr);

                DaoLocker dao = new DaoLocker();

                // Asegúrate de que tu método en el DAO ejecute:
                // UPDATE SOLICITUD SET ID_LOCKER = NULL WHERE ID_SOLICITUD = ?
                boolean actualizado = dao.liberarCasilleroPorEstudiante(idSolicitud);

                System.out.println("Resultado de liberar casillero en BD: " + actualizado);

                if (actualizado) {
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo actualizar el registro");
                }
            } catch (NumberFormatException e) {
                System.out.println("Error: Formato de número inválido -> " + e.getMessage());
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
            }
        } else {
            System.out.println("Error: Falta el parámetro idSolicitud");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Falta el ID de la solicitud");
        }
    }
}