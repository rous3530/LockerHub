package mx.edu.utez.locker.controller; // Ajusta tu paquete según tu estructura

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.edu.utez.locker.dao.DaoLocker; // Ajusta según tu DAO

import java.io.IOException;

@WebServlet(name = "QuitarCasilleroServlet", value = "/quitar-casillero")
public class QuitarCasilleroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idEstudianteStr = request.getParameter("idEstudiante");

        if (idEstudianteStr != null && !idEstudianteStr.isEmpty()) {
            try {
                int idEstudiante = Integer.parseInt(idEstudianteStr);

                DaoLocker dao = new DaoLocker();
                // Método en tu DAO que libera el casillero del alumno
                boolean actualizado = dao.liberarCasilleroPorEstudiante(idEstudiante);

                if (actualizado) {
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo actualizar el registro");
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Falta el ID del estudiante");
        }
    }
}